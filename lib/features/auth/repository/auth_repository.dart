import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_caller.dart';
import '../../../core/network/response_data.dart';
import 'package:get/get.dart';

/// Handles all authentication-related network calls.
/// Controllers should inject this instead of using [NetworkCaller] directly.
class AuthRepository {
  final NetworkCaller _caller;

  AuthRepository({NetworkCaller? networkCaller}) : _caller = networkCaller ?? Get.find<NetworkCaller>();

  /// Sends login credentials to the API.
  Future<ResponseData<dynamic>> login({
    required String email,
    required String password,
  }) {
    return _caller.postRequest(
      ApiEndpoints.loginEndpoint,
      body: {'email': email, 'password': password},
      isAuthCall: true,
    );
  }

  /// Logs out the user by revoking the token on the server.
  Future<ResponseData<dynamic>> logout() {
    return _caller.postRequest(
      '${ApiEndpoints.baseUrl}/auth/logout',
    );
  }
}
