import 'package:file_uploader/core/network/api_endpoints.dart';
import 'package:file_uploader/core/network/network_caller.dart';
import 'package:file_uploader/core/network/response_data.dart';
import 'package:get/get.dart';

/// Handles all home/feed related network calls.
/// Controllers should inject this instead of using [NetworkCaller] directly.
class HomeRepository {
  final NetworkCaller _caller;

  HomeRepository({NetworkCaller? networkCaller}) : _caller = networkCaller ?? Get.find<NetworkCaller>();

  /// Fetches a paginated list of posts.
  Future<ResponseData<dynamic>> getPosts({required int page, required int limit}) {
    return _caller.getRequest(
      '${ApiEndpoints.posts}?_page=$page&_limit=$limit',
      showLoading: false,
      showErrorMessage: false,
    );
  }
}
