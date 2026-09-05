import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../routes/app_routes.dart';
import '../storage/storage_service.dart';
import '../utils/logger.dart';
import 'api_endpoints.dart';
import 'app_error.dart';
import 'response_data.dart';

/// A pure network layer that handles requests, token refresh, and connectivity.
/// UI feedback (snackbars/dialogs) should be handled by the Repository or Controller.
class NetworkCaller {
  final _timeoutSeconds = 30;
  final StorageService _storage;
  final http.Client _client;
  final Future<bool> Function() _connectivityCheck;

  /// All collaborators are injectable so this class can be unit-tested without
  /// real sockets or platform plugins. Production code uses the defaults.
  NetworkCaller({
    StorageService? storage,
    http.Client? client,
    Future<bool> Function()? connectivityCheck,
  }) : _storage = storage ?? Get.find<StorageService>(),
       _client = client ?? http.Client(),
       _connectivityCheck = connectivityCheck ?? _defaultConnectivityCheck;

  static Future<bool> _defaultConnectivityCheck() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  // ─── Auth Headers ─────────────────────────────────────────────────────────

  Future<Map<String, String>> _getHeaders({bool isAuthCall = false}) async {
    var token = await _storage.getAccessToken();

    // Check for expiration and refresh if necessary
    if (!isAuthCall && _storage.isAccessTokenExpired()) {
      final refreshed = await _refreshToken();
      if (!refreshed) await _logout();
      token = await _storage.getAccessToken();
    }

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─── Token Refresh ────────────────────────────────────────────────────────

  /// Guards against concurrent refreshes. Most backends rotate the refresh
  /// token on use, so N parallel 401s firing N refreshes would invalidate each
  /// other and log the user out. Callers arriving while a refresh is in flight
  /// await that same result instead of starting their own.
  Completer<bool>? _refreshCompleter;

  Future<bool> _refreshToken() {
    final inFlight = _refreshCompleter;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    unawaited(
      _performRefresh()
          .then((success) {
            _refreshCompleter = null;
            completer.complete(success);
          })
          .catchError((Object e) {
            _refreshCompleter = null;
            AppLogger.logError('Token refresh failed', e);
            completer.complete(false);
          }),
    );

    return completer.future;
  }

  Future<bool> _performRefresh() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      AppLogger.logInfo('Refreshing token...');

      final response = await _client.post(
        Uri.parse(ApiEndpoints.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded is Map<String, dynamic> ? decoded['data'] : null;

        if (data is Map<String, dynamic>) {
          final accessToken = data['access_token'];
          final refreshToken = data['refresh_token'];
          final expiresIn = data['expires_in'];

          if (accessToken is String && refreshToken is String) {
            await _storage.saveTokens(
              accessToken: accessToken,
              refreshToken: refreshToken,
              expiresIn: expiresIn is int ? expiresIn : 0,
            );
            AppLogger.logInfo('Token refreshed successfully');
            return true;
          }
        }
        AppLogger.logError('Refresh response did not contain valid tokens');
      }
    } catch (e) {
      AppLogger.logError('Token refresh failed', e);
    }
    return false;
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> _logout() async {
    await _storage.clearAuth();
    await Get.offAllNamed<void>(AppRoutes.login);
  }

  // ─── Connectivity Check ───────────────────────────────────────────────────

  // ─── Core Request ─────────────────────────────────────────────────────────

  Future<ResponseData<dynamic>> _sendRequest({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    bool isAuthCall = false,
    bool isRetry = false,
  }) async {
    if (!await _connectivityCheck()) {
      return ResponseData.failure(error: AppError.noInternet);
    }

    try {
      final headers = await _getHeaders(isAuthCall: isAuthCall);
      AppLogger.logInfo('[$method] $url');
      if (body != null) AppLogger.logDebug('Body: ${jsonEncode(body)}');

      final uri = Uri.parse(url);
      http.Response response;

      switch (method) {
        case 'GET':
          response = await _client
              .get(uri, headers: headers)
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'POST':
          response = await _client
              .post(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'PUT':
          response = await _client
              .put(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'PATCH':
          response = await _client
              .patch(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'DELETE':
          response = await _client
              .delete(uri, headers: headers)
              .timeout(Duration(seconds: _timeoutSeconds));
          break;
        default:
          throw Exception('Invalid HTTP method: $method');
      }

      // Handle Unauthorized (401)
      if (response.statusCode == 401 && !isAuthCall && !isRetry) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return await _sendRequest(
            url: url,
            method: method,
            body: body,
            isRetry: true,
          );
        } else {
          await _logout();
          return ResponseData.failure(
            error: AppError.unauthorized,
            statusCode: 401,
          );
        }
      }

      return _handleResponse(response);
    } on TimeoutException {
      return ResponseData.failure(error: AppError.timeout, statusCode: 408);
    } catch (e) {
      AppLogger.logError('Network error', e);
      return ResponseData.failure(error: AppError.unknown);
    }
  }

  // ─── Response Handler ─────────────────────────────────────────────────────

  ResponseData<dynamic> _handleResponse(http.Response response) {
    AppLogger.logInfo('Status: ${response.statusCode}');
    AppLogger.logDebug('Body: ${response.body}');

    try {
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle common API success structures
        if (decoded is Map<String, dynamic> &&
            decoded.containsKey('status') &&
            decoded['status'] == 'success') {
          return ResponseData.success(
            statusCode: response.statusCode,
            data: decoded['data'],
          );
        }
        return ResponseData.success(
          statusCode: response.statusCode,
          data: decoded,
        );
      }

      final errorMsg = decoded is Map ? (decoded['message'] as String?) : null;
      final appError = AppError.fromStatusCode(
        response.statusCode,
        message: errorMsg,
      );

      return ResponseData.failure(
        error: appError,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ResponseData.failure(
        error: AppError.unknown,
        statusCode: response.statusCode,
      );
    }
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  Future<ResponseData<dynamic>> getRequest(String url) {
    return _sendRequest(url: url, method: 'GET');
  }

  Future<ResponseData<dynamic>> postRequest(
    String url, {
    Map<String, dynamic>? body,
    bool isAuthCall = false,
  }) {
    return _sendRequest(
      url: url,
      method: 'POST',
      body: body,
      isAuthCall: isAuthCall,
    );
  }

  Future<ResponseData<dynamic>> putRequest(
    String url, {
    Map<String, dynamic>? body,
  }) {
    return _sendRequest(url: url, method: 'PUT', body: body);
  }

  Future<ResponseData<dynamic>> patchRequest(
    String url, {
    Map<String, dynamic>? body,
  }) {
    return _sendRequest(url: url, method: 'PATCH', body: body);
  }

  Future<ResponseData<dynamic>> deleteRequest(String url) {
    return _sendRequest(url: url, method: 'DELETE');
  }

  // ─── Multipart ────────────────────────────────────────────────────────────

  Future<ResponseData<dynamic>> multipartPostRequest({
    required String url,
    required Map<String, String> fields,
    required String fileFieldName,
    required String filePath,
  }) async {
    if (!await _connectivityCheck()) {
      return ResponseData.failure(error: AppError.noInternet);
    }

    try {
      final headers = await _getHeaders();
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        if (headers.containsKey('Authorization'))
          'Authorization': headers['Authorization']!,
      });

      request.fields.addAll(fields);
      request.files.add(
        await http.MultipartFile.fromPath(fileFieldName, filePath),
      );

      AppLogger.logInfo('Uploading to: $url');
      final streamedResponse = await _client
          .send(request)
          .timeout(Duration(seconds: _timeoutSeconds));
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      AppLogger.logError('Upload error', e);
      return ResponseData.failure(error: AppError.unknown);
    }
  }
}
