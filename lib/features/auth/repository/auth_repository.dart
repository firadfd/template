import 'package:file_uploader/core/network/api_endpoints.dart';
import 'package:file_uploader/core/network/network_caller.dart';
import 'package:file_uploader/core/network/response_data.dart';
import 'package:get/get.dart';

/// Handles all authentication-related network calls.
/// Controllers should inject this instead of using [NetworkCaller] directly.
class AuthRepository {
  final NetworkCaller _caller;

  AuthRepository({NetworkCaller? networkCaller}) : _caller = networkCaller ?? Get.find<NetworkCaller>();

  /// Sends login credentials to the API.
  /// Returns [ResponseData] with the auth token payload on success.
  Future<ResponseData<dynamic>> login({
    required String email,
    required String password,
  }) {
    return _caller.postRequest(
      ApiEndpoints.loginEndpoint,
      body: {'email': email, 'password': password},
      isAuthCall: true,
      showSuccessMessage: false,
    );
  }

  /// Logs out the user by revoking the token on the server (if applicable).
  /// Token removal from local storage is handled separately by [StorageService].
  Future<ResponseData<dynamic>> logout({String? accessToken}) {
    return _caller.postRequest(
      '${ApiEndpoints.baseUrl}/auth/logout',
      isAuthCall: false,
      showLoading: false,
      showSuccessMessage: false,
      showErrorMessage: false,
    );
  }
}
