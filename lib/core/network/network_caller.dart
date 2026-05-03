import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../storage/storage_service.dart';
import '../utils/logger.dart';
import '../../routes/app_routes.dart';
import 'api_endpoints.dart';
import 'app_error.dart';
import 'response_data.dart';

/// A pure network layer that handles requests, token refresh, and connectivity.
/// UI feedback (snackbars/dialogs) should be handled by the Repository or Controller.
class NetworkCaller {
  final _timeoutSeconds = 30;
  final StorageService _storage = Get.find<StorageService>();

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

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      AppLogger.logInfo('Refreshing token...');

      final response = await http.post(
        Uri.parse(ApiEndpoints.refreshToken),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == 'success') {
          final data = decoded['data'];
          await _storage.saveTokens(
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'],
            expiresIn: data['expires_in'],
          );
          AppLogger.logInfo('Token refreshed successfully');
          return true;
        }
      }
    } catch (e) {
      AppLogger.logError('Token refresh failed', e);
    }
    return false;
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> _logout() async {
    await _storage.clearAuth();
    Get.offAllNamed(AppRoutes.login);
  }

  // ─── Connectivity Check ───────────────────────────────────────────────────

  Future<bool> _isConnected() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  // ─── Core Request ─────────────────────────────────────────────────────────

  Future<ResponseData<dynamic>> _sendRequest({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    bool isAuthCall = false,
    bool isRetry = false,
  }) async {
    if (!await _isConnected()) {
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
          response = await http.get(uri, headers: headers).timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'POST':
          response = await http.post(uri, headers: headers, body: body != null ? jsonEncode(body) : null).timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'PUT':
          response = await http.put(uri, headers: headers, body: body != null ? jsonEncode(body) : null).timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'PATCH':
          response = await http.patch(uri, headers: headers, body: body != null ? jsonEncode(body) : null).timeout(Duration(seconds: _timeoutSeconds));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers).timeout(Duration(seconds: _timeoutSeconds));
          break;
        default:
          throw Exception('Invalid HTTP method: $method');
      }

      // Handle Unauthorized (401)
      if (response.statusCode == 401 && !isAuthCall && !isRetry) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return _sendRequest(
            url: url,
            method: method,
            body: body,
            isRetry: true,
          );
        } else {
          await _logout();
          return ResponseData.failure(error: AppError.unauthorized, statusCode: 401);
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
        if (decoded is Map<String, dynamic> && decoded.containsKey('status') && decoded['status'] == 'success') {
          return ResponseData.success(statusCode: response.statusCode, data: decoded['data']);
        }
        return ResponseData.success(statusCode: response.statusCode, data: decoded);
      }

      final errorMsg = decoded is Map ? (decoded['message'] as String?) : null;
      final appError = AppError.fromStatusCode(response.statusCode, message: errorMsg);

      return ResponseData.failure(error: appError, statusCode: response.statusCode);
    } catch (e) {
      return ResponseData.failure(error: AppError.unknown, statusCode: response.statusCode);
    }
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  Future<ResponseData<dynamic>> getRequest(String url) {
    return _sendRequest(url: url, method: 'GET');
  }

  Future<ResponseData<dynamic>> postRequest(String url, {Map<String, dynamic>? body, bool isAuthCall = false}) {
    return _sendRequest(url: url, method: 'POST', body: body, isAuthCall: isAuthCall);
  }

  Future<ResponseData<dynamic>> putRequest(String url, {Map<String, dynamic>? body}) {
    return _sendRequest(url: url, method: 'PUT', body: body);
  }

  Future<ResponseData<dynamic>> patchRequest(String url, {Map<String, dynamic>? body}) {
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
    if (!await _isConnected()) {
      return ResponseData.failure(error: AppError.noInternet);
    }

    try {
      final headers = await _getHeaders();
      final uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);
      
      request.headers.addAll({
        'Accept': 'application/json',
        if (headers.containsKey('Authorization')) 'Authorization': headers['Authorization']!,
      });
      
      request.fields.addAll(fields);
      request.files.add(await http.MultipartFile.fromPath(fileFieldName, filePath));

      AppLogger.logInfo('Uploading to: $url');
      final streamedResponse = await request.send().timeout(Duration(seconds: _timeoutSeconds));
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse(response);
    } catch (e) {
      AppLogger.logError('Upload error', e);
      return ResponseData.failure(error: AppError.unknown);
    }
  }
}
