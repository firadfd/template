import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_uploader/core/utils/logger.dart';
import 'package:file_uploader/core/network/network_caller.dart';
import 'package:file_uploader/core/network/api_endpoints.dart';
import '../model/home_model.dart';

class HomeController extends GetxController {
  final NetworkCaller _networkCaller = Get.find<NetworkCaller>();

  final RxBool isLoading = false.obs;
  final RxBool isMoreLoading = false.obs;
  final RxString errorMsg = ''.obs;

  final RxList<HomeModel> posts = <HomeModel>[].obs;
  final ScrollController scrollController = ScrollController();

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMoreData = true;

  @override
  void onInit() {
    super.onInit();
    _fetchInitialData();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;
    try {
      final position = scrollController.positions.last;
      if (position.extentAfter < 200) {
        _loadMoreData();
      }
    } catch (e) {
      // Ignore scroll check errors safely during route rebuilds
    }
  }

  Future<List<HomeModel>> _getPosts(int page, int limit) async {
    try {
      final response = await _networkCaller.getRequest(
        '${ApiEndpoints.posts}?_page=$page&_limit=$limit',
        showLoading: false,
        showErrorMessage: false,
      );

      if (response.isSuccess) {
        List<dynamic> data = response.responseData;
        return data.map((json) => HomeModel.fromJson(json)).toList();
      } else {
        throw Exception(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'API Request Failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _fetchInitialData() async {
    try {
      if (posts.isEmpty) {
        isLoading.value = true;
      }
      errorMsg.value = '';
      _currentPage = 1;
      _hasMoreData = true;

      final data = await _getPosts(_currentPage, _limit);
      posts.clear();
      posts.addAll(data);
      if (data.length < _limit) {
        _hasMoreData = false;
      }
    } catch (e) {
      errorMsg.value = e.toString().replaceAll('Exception: ', '');
      AppLogger.logError('Failed to fetch initial data', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMoreData() async {
    if (isMoreLoading.value || isLoading.value || !_hasMoreData) return;

    try {
      isMoreLoading.value = true;
      _currentPage++;
      final data = await _getPosts(_currentPage, _limit);
      if (data.isEmpty || data.length < _limit) {
        _hasMoreData = false;
      }
      posts.addAll(data);
    } catch (e) {
      _currentPage--;
      AppLogger.logError('Failed to load more data', e);
      Get.snackbar('Error'.tr, e.toString().replaceAll('Exception: ', ''));
    } finally {
      isMoreLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _fetchInitialData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
