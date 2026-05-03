import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template/features/home/controller/home_controller.dart';
import 'package:template/features/home/model/home_model.dart';
import 'package:template/features/home/repository/home_repository.dart';
import '../../mocks/mocks.dart';

void main() {
  late HomeController controller;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    
    // Reset GetX to ensure a clean state
    Get.testMode = true;
    Get.reset();
    
    Get.put<HomeRepository>(mockHomeRepository);
    
    // Stub the initial fetch that happens in onInit
    when(() => mockHomeRepository.getPosts(
      page: any(named: 'page'), 
      limit: any(named: 'limit'),
    )).thenAnswer((_) async => <HomeModel>[]);

    controller = HomeController();
  });

  tearDown(() {
    Get.reset();
  });

  group('HomeController Tests', () {
    test('initial state is correct', () {
      expect(controller.posts.isEmpty, true);
      expect(controller.errorMsg.value, '');
    });

    test('refreshData fetches posts and updates state with correct model mapping', () async {
      // Arrange
      final mockPosts = [
        const HomeModel(id: 1, title: 'Post 1', body: 'Body 1'),
        const HomeModel(id: 2, title: 'Post 2', body: 'Body 2'),
      ];
      
      when(() => mockHomeRepository.getPosts(
        page: any(named: 'page'), 
        limit: any(named: 'limit'),
      )).thenAnswer((_) async => mockPosts);

      // Act
      await controller.refreshData();

      // Assert
      expect(controller.posts.length, 2);
      expect(controller.posts[0].id, 1);
      expect(controller.posts[0].title, 'Post 1');
      expect(controller.posts[1].id, 2);
      expect(controller.isLoading.value, false);
      expect(controller.errorMsg.value, '');
    });

    test('handles error state correctly from repository exception', () async {
      // Arrange
      const errorMessage = 'Failed to load posts';
      when(() => mockHomeRepository.getPosts(
        page: any(named: 'page'), 
        limit: any(named: 'limit'),
      )).thenThrow(Exception(errorMessage));

      // Act
      await controller.refreshData();

      // Assert
      expect(controller.errorMsg.value, errorMessage);
      expect(controller.posts.isEmpty, true);
    });
  });
}
