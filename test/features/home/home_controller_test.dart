import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:file_uploader/features/home/controller/home_controller.dart';
import 'package:file_uploader/features/home/model/home_model.dart';
import 'package:file_uploader/features/home/repository/home_repository.dart';
import 'package:file_uploader/core/network/response_data.dart';
import 'package:file_uploader/core/network/app_error.dart';
import '../../mocks/mocks.dart';

void main() {
  late HomeController controller;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    Get.put<HomeRepository>(mockHomeRepository);
    
    registerFallbackValue(const HomeModel());

    when(() => mockHomeRepository.getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
        .thenAnswer((_) async => ResponseData.success(statusCode: 200, data: []));

    controller = HomeController();
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController Tests', () {
    test('initial state is correct', () {
      expect(controller.isLoading.value, false);
      expect(controller.posts.isEmpty, true);
    });

    test('refreshData fetches posts and updates state', () async {
      // Arrange
      final mockPosts = [
        const HomeModel(id: 1, title: 'Post 1', body: 'Body 1'),
        const HomeModel(id: 2, title: 'Post 2', body: 'Body 2'),
      ];
      
      final mockResponse = ResponseData.success(
        statusCode: 200, 
        data: mockPosts.map((e) => {
          'id': e.id,
          'title': e.title,
          'body': e.body,
        }).toList(),
      );

      when(() => mockHomeRepository.getPosts(page: 1, limit: 10))
          .thenAnswer((_) async => mockResponse);

      // Act
      await controller.refreshData();

      // Assert
      expect(controller.posts.length, 2);
      expect(controller.posts[0].title, 'Post 1');
      expect(controller.isLoading.value, false);
    });

    test('handles error state correctly', () async {
      // Arrange
      when(() => mockHomeRepository.getPosts(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => ResponseData.failure(error: const AppError(message: 'Error fetching posts')));

      // Act
      await controller.refreshData();

      // Assert
      expect(controller.errorMsg.value, 'Error fetching posts');
      expect(controller.posts.isEmpty, true);
    });
  });
}
