import 'dart:async';
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../storage/storage_service.dart';
import '../utils/logger.dart';
import '../../routes/app_routes.dart';
import 'api_endpoints.dart';
import 'response_data.dart';

class NetworkCaller {
  final int timeoutDuration = 80;
  final StorageService _storage = Get.find<StorageService>();


  Future<Map<String, String>> _getHeaders({bool isAuthCall = false}) async {
    String? token = _storage.getAccessToken();

    /// Check expiry before request
    if (!isAuthCall && _storage.isAccessTokenExpired()) {
      final refreshed = await _refreshToken();
      if (!refreshed) {
        await _logout();
      }
      token = _storage.getAccessToken();
    }

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = _storage.getRefreshToken();
      if (refreshToken == null) return false;

      AppLogger.logInfo("Refreshing token...");

      final response = await http.post(
        Uri.parse(ApiEndpoints.baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"refresh_token": refreshToken}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == "success") {
          final data = decoded["data"];

          await _storage.saveTokens(
            accessToken: data["access_token"],
            refreshToken: data["refresh_token"],
            expiresIn: data["expires_in"],
          );

          AppLogger.logInfo("Token refreshed");
          return true;
        }
      }
    } catch (e) {
      AppLogger.logError("Refresh failed: $e");
    }

    return false;
  }


  Future<void> _logout() async {
    await _storage.clearAuth();
    // TODO
    // Get.offAllNamed(AppRoutes.home);
  }


  Future<ResponseData> _sendRequest({
    required String url,
    required String method,
    Map<String, dynamic>? body,
    bool isAuthCall = false,
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) async {
    try {
      if (showLoading) {
        EasyLoading.show(status: 'loading...');
      }
      final headers = await _getHeaders(isAuthCall: isAuthCall);

      AppLogger.logInfo("URL: $url");
      AppLogger.logInfo("Method: $method");
      AppLogger.logInfo("Headers: $headers");
      AppLogger.logInfo("Body: ${body != null ? jsonEncode(body) : 'EMPTY'}");
      http.Response response;
      final uri = Uri.parse(url);
      switch (method) {
        case 'GET':
          response = await http
              .get(uri, headers: headers)
              .timeout(Duration(seconds: timeoutDuration));
          break;

        case 'POST':
          response = await http
              .post(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(Duration(seconds: timeoutDuration));
          break;

        case 'PUT':
          response = await http
              .put(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(Duration(seconds: timeoutDuration));
          break;

        case 'PATCH':
          response = await http
              .patch(
                uri,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(Duration(seconds: timeoutDuration));
          break;

        case 'DELETE':
          response = await http
              .delete(uri, headers: headers)
              .timeout(Duration(seconds: timeoutDuration));
          break;

        default:
          throw Exception("Invalid HTTP method");
      }

      /// If token invalid → refresh → retry once
      // Actually json placeholder returns 404/others, adapting it cleanly
      if (response.statusCode == 401 && !isAuthCall) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          return _sendRequest(
            url: url,
            method: method,
            body: body,
            showLoading: showLoading,
            showSuccessMessage: showSuccessMessage,
            showErrorMessage: showErrorMessage,
          );
        } else {
          await _logout();
        }
      }

      return _handleResponse(
        response,
        showSuccessMessage: showSuccessMessage,
        showErrorMessage: showErrorMessage,
      );
    } catch (e) {
      return _handleError(e);
    } finally {
      if (showLoading) {
        EasyLoading.dismiss();
      }
    }
  }

  Future<ResponseData> getRequest(
    String url, {
    bool showLoading = true,
    bool showSuccessMessage = false,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(
      url: url,
      method: 'GET',
      showLoading: showLoading,
      showSuccessMessage: showSuccessMessage,
      showErrorMessage: showErrorMessage,
    );
  }

  Future<ResponseData> postRequest(
    String url, {
    Map<String, dynamic>? body,
    bool isAuthCall = false,
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(
      url: url,
      method: 'POST',
      body: body,
      isAuthCall: isAuthCall,
      showLoading: showLoading,
      showSuccessMessage: showSuccessMessage,
      showErrorMessage: showErrorMessage,
    );
  }

  Future<ResponseData> putRequest(
    String url, {
    Map<String, dynamic>? body,
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(
      url: url,
      method: 'PUT',
      body: body,
      showLoading: showLoading,
      showSuccessMessage: showSuccessMessage,
      showErrorMessage: showErrorMessage,
    );
  }

  Future<ResponseData> patchRequest(
    String url, {
    Map<String, dynamic>? body,
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(
      url: url,
      method: 'PATCH',
      body: body,
      showLoading: showLoading,
      showSuccessMessage: showSuccessMessage,
      showErrorMessage: showErrorMessage,
    );
  }

  Future<ResponseData> deleteRequest(
    String url, {
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    return _sendRequest(
      url: url,
      method: 'DELETE',
      showLoading: showLoading,
      showSuccessMessage: showSuccessMessage,
      showErrorMessage: showErrorMessage,
    );
  }

  Future<ResponseData> multipartPostRequest({
    required String url,
    required Map<String, String> fields,
    required String fileFieldName,
    required String filePath,
    bool showLoading = true,
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) async {
    try {
      if (showLoading) {
        EasyLoading.show(status: 'loading...');
      }
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

      AppLogger.logInfo("Uploading image to: $url");

      final streamedResponse = await request.send().timeout(
        Duration(seconds: timeoutDuration),
      );

      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(
        response,
        showSuccessMessage: showSuccessMessage,
        showErrorMessage: showErrorMessage,
      );
    } catch (e) {
      return _handleError(e);
    } finally {
      if (showLoading) {
        EasyLoading.dismiss();
      }
    }
  }


  ResponseData _handleResponse(
    http.Response response, {
    bool showSuccessMessage = true,
    bool showErrorMessage = true,
  }) {
    AppLogger.logInfo("Status: ${response.statusCode}");
    AppLogger.logInfo("Body: ${response.body}");

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Adjusted slightly to handle jsonplaceholder mock array without status=success
      // We assume List or map
      if (decoded is Map<String, dynamic> &&
          decoded.containsKey('status') &&
          decoded['status'] == 'success') {
        if (showSuccessMessage) {
          EasyLoading.showSuccess(decoded['message'] ?? 'Success');
        }
        return ResponseData(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decoded['data'],
          errorMessage: decoded['message'] ?? '',
        );
      }
      return ResponseData(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: decoded,
        errorMessage: '',
      );
    }

    if (showErrorMessage) {
      EasyLoading.showError(decoded['message'] ?? 'Request failed');
    }
    return ResponseData(
      isSuccess: false,
      statusCode: response.statusCode,
      responseData: decoded,
      errorMessage: decoded['message'] ?? 'Request failed',
    );
  }

  ResponseData _handleError(dynamic error) {
    AppLogger.logError("Network error: $error");

    if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        responseData: '',
        errorMessage: 'Request timeout',
      );
    }

    return ResponseData(
      isSuccess: false,
      statusCode: 500,
      responseData: '',
      errorMessage: 'Network error',
    );
  }
}
