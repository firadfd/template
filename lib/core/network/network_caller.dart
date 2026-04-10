import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../storage/storage_service.dart';
import '../utils/app_strings.dart';
import '../utils/logger.dart';
import '../../routes/app_routes.dart';
import 'api_endpoints.dart';
import 'app_error.dart';
import 'response_data.dart';

class NetworkCaller {
  final int _timeoutSeconds = 80;
  final StorageService _storage = Get.find<StorageService>();

  // ─── Auth Headers ─────────────────────────────────────────────────────────

  Future<Map<String, String>> _getHeaders({bool isAuthCall = false}) async {
    String? token = await _storage.getAccessToken();

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
        Uri.parse(ApiEndpoints.refreshToken), // ✅ Correct endpoint
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
    Get.offAllNamed(AppRoutes.login); // ✅ Navigate to login after clearing
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
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
    bool isRetry = false, // ✅ Recursion guard
  }) async {
    // ✅ Connectivity check before any network call
    if (!await _isConnected()) {
      if (showErrorMessage) {
        EasyLoading.showError(AppStrings.noInternet.tr);
      }
      return ResponseData.failure(error: AppError.noInternet);
    }

    try {
      if (showLoading) EasyLoading.show(status: AppStrings.loading.tr);

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

      // ✅ Token refresh + retry (with recursion guard via isRetry flag)
      if (response.statusCode == 401 && !isAuthCall && !isRetry) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return _sendRequest(
            url: url,
            method: method,
            body: body,
            showLoading: showLoading,
            showSuccessMessage: showSuccessMessage,
            showErrorMessage: showErrorMessage,
            isRetry: true, // ✅ Prevents second retry
          );
        } else {
          await _logout();
          return ResponseData.failure(error: AppError.unauthorized, statusCode: 401);
        }
      }

      return _handleResponse(response, showSuccessMessage: showSuccessMessage, showErrorMessage: showErrorMessage);
    } on TimeoutException {
      if (showErrorMessage) EasyLoading.showError(AppStrings.requestTimeout.tr);
      return ResponseData.failure(error: AppError.timeout, statusCode: 408);
    } catch (e) {
      AppLogger.logError('Network error', e);
      if (showErrorMessage) EasyLoading.showError(AppStrings.networkError.tr);
      return ResponseData.failure(error: AppError.unknown);
    } finally {
      if (showLoading) EasyLoading.dismiss();
    }
  }

  // ─── Response Handler ─────────────────────────────────────────────────────

  ResponseData<dynamic> _handleResponse(
    http.Response response, {
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    AppLogger.logInfo('Status: ${response.statusCode}');
    AppLogger.logDebug('Body: ${response.body}');

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded is Map<String, dynamic> && decoded.containsKey('status') && decoded['status'] == 'success') {
        if (showSuccessMessage) {
          EasyLoading.showSuccess(decoded['message'] ?? AppStrings.success.tr);
        }
        return ResponseData.success(statusCode: response.statusCode, data: decoded['data']);
      }
      return ResponseData.success(statusCode: response.statusCode, data: decoded);
    }

    final errorMsg = decoded is Map ? (decoded['message'] as String?) : null;
    final appError = AppError.fromStatusCode(response.statusCode, message: errorMsg);

    if (showErrorMessage) EasyLoading.showError(appError.message);
    return ResponseData.failure(error: appError, statusCode: response.statusCode);
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  Future<ResponseData<dynamic>> getRequest(
    String url, {
    bool showLoading = true,
    bool showSuccessMessage = false,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(url: url, method: 'GET', showLoading: showLoading, showSuccessMessage: showSuccessMessage, showErrorMessage: showErrorMessage);
  }

  Future<ResponseData<dynamic>> postRequest(
    String url, {
    Map<String, dynamic>? body,
    bool isAuthCall = false,
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(url: url, method: 'POST', body: body, isAuthCall: isAuthCall, showLoading: showLoading, showSuccessMessage: showSuccessMessage, showErrorMessage: showErrorMessage);
  }

  Future<ResponseData<dynamic>> putRequest(
    String url, {
    Map<String, dynamic>? body,
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(url: url, method: 'PUT', body: body, showLoading: showLoading, showSuccessMessage: showSuccessMessage, showErrorMessage: showErrorMessage);
  }

  Future<ResponseData<dynamic>> patchRequest(
    String url, {
    Map<String, dynamic>? body,
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(url: url, method: 'PATCH', body: body, showLoading: showLoading, showSuccessMessage: showSuccessMessage, showErrorMessage: showErrorMessage);
  }

  Future<ResponseData<dynamic>> deleteRequest(
    String url, {
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(url: url, method: 'DELETE', showLoading: showLoading, showSuccessMessage: showSuccessMessage, showErrorMessage: showErrorMessage);
  }

  // ─── Multipart ────────────────────────────────────────────────────────────

  Future<ResponseData<dynamic>> multipartPostRequest({
    required String url,
    required Map<String, String> fields,
    required String fileFieldName,
    required String filePath,
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) async {
    if (!await _isConnected()) {
      if (showErrorMessage) EasyLoading.showError(AppStrings.noInternet.tr);
      return ResponseData.failure(error: AppError.noInternet);
    }

    try {
      if (showLoading) EasyLoading.show(status: AppStrings.loading.tr);

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
      return _handleResponse(response, showSuccessMessage: showSuccessMessage, showErrorMessage: showErrorMessage);
    } catch (e) {
      AppLogger.logError('Upload error', e);
      if (showErrorMessage) EasyLoading.showError(AppStrings.networkError.tr);
      return ResponseData.failure(error: AppError.unknown);
    } finally {
      if (showLoading) EasyLoading.dismiss();
    }
  }
}
