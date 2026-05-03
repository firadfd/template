import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_caller.dart';
import '../model/home_model.dart';
import 'package:get/get.dart';

/// Handles all home/feed related network calls and data mapping.
/// This ensures the Controller only deals with rich objects, not raw JSON.
class HomeRepository {
  final NetworkCaller _caller;

  HomeRepository({NetworkCaller? networkCaller}) : _caller = networkCaller ?? Get.find<NetworkCaller>();

  /// Fetches a paginated list of posts and maps them to [HomeModel].
  Future<List<HomeModel>> getPosts({required int page, required int limit}) async {
    final response = await _caller.getRequest(
      '${ApiEndpoints.posts}?_page=$page&_limit=$limit',
    );

    if (response.isSuccess && response.data != null) {
      final data = response.data as List<dynamic>;
      return data.map((json) => HomeModel.fromJson(json as Map<String, dynamic>)).toList();
    }

    // Rethrow or return a Result type. Here we throw to let the Controller handle the error message.
    throw Exception(response.errorMessage.isNotEmpty ? response.errorMessage : 'Failed to load posts');
  }
}
