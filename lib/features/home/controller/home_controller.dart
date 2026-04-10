import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:file_uploader/core/utils/app_strings.dart';
import 'package:file_uploader/core/utils/logger.dart';
import '../model/home_model.dart';
import '../repository/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository _homeRepository = Get.find<HomeRepository>();

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
      if (position.extentAfter < 200) _loadMoreData();
    } catch (_) {
      // Ignore scroll errors during route rebuilds
    }
  }

  Future<List<HomeModel>> _fetchPostsPage(int page, int limit) async {
    final response = await _homeRepository.getPosts(page: page, limit: limit);

    if (response.isSuccess && response.data != null) {
      final data = response.data as List<dynamic>;
      return data.map((json) => HomeModel.fromJson(json as Map<String, dynamic>)).toList();
    }

    throw Exception(response.errorMessage.isNotEmpty ? response.errorMessage : 'API Request Failed');
  }

  Future<void> _fetchInitialData() async {
    try {
      if (posts.isEmpty) isLoading.value = true;
      errorMsg.value = '';
      _currentPage = 1;
      _hasMoreData = true;

      final data = await _fetchPostsPage(_currentPage, _limit);
      posts
        ..clear()
        ..addAll(data);
      if (data.length < _limit) _hasMoreData = false;
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
      final data = await _fetchPostsPage(_currentPage, _limit);
      if (data.isEmpty || data.length < _limit) _hasMoreData = false;
      posts.addAll(data);
    } catch (e) {
      _currentPage--;
      AppLogger.logError('Failed to load more data', e);
      Get.snackbar(AppStrings.error.tr, e.toString().replaceAll('Exception: ', ''));
    } finally {
      isMoreLoading.value = false;
    }
  }

  Future<void> refreshData() async => _fetchInitialData();

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
