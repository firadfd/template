import 'package:get/get.dart';

import '../../../core/config/env_config.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/network_caller.dart';
import '../../../core/network/response_data.dart';
import '../model/auth_tokens.dart';

/// Handles all authentication-related network calls.
/// Controllers should inject this instead of using [NetworkCaller] directly.
class AuthRepository {
  final NetworkCaller _caller;

  AuthRepository({NetworkCaller? networkCaller})
    : _caller = networkCaller ?? Get.find<NetworkCaller>();

  /// Sends login credentials to the API and returns typed tokens.
  Future<ResponseData<AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    if (EnvConfig.useMockAuth) return _mockLogin();

    final response = await _caller.postRequest(
      ApiEndpoints.loginEndpoint,
      body: {'username': email, 'password': password},
      isAuthCall: true,
    );

    if (!response.isSuccess) {
      return ResponseData<AuthTokens>.failure(
        error: response.error ?? AppError.unknown,
        statusCode: response.statusCode,
      );
    }

    try {
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Unexpected auth response shape.');
      }
      return ResponseData<AuthTokens>.success(
        statusCode: response.statusCode,
        data: AuthTokens.fromJson(data),
      );
    } on FormatException catch (e) {
      return ResponseData<AuthTokens>.failure(
        error: AppError(
          message: e.message,
          statusCode: response.statusCode,
          errorCode: 'MALFORMED_RESPONSE',
        ),
        statusCode: response.statusCode,
      );
    }
  }

  /// Logs out the user by revoking the token on the server.
  Future<ResponseData<dynamic>> logout() {
    if (EnvConfig.useMockAuth) {
      return Future.value(ResponseData<dynamic>.success(statusCode: 200));
    }
    return _caller.postRequest(ApiEndpoints.logoutEndpoint);
  }

  /// Backend-free login used when [EnvConfig.useMockAuth] is on.
  Future<ResponseData<AuthTokens>> _mockLogin() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return ResponseData<AuthTokens>.success(
      statusCode: 200,
      data: const AuthTokens(
        accessToken: 'mock-access-token',
        refreshToken: 'mock-refresh-token',
        expiresIn: 3600,
      ),
    );
  }
}
