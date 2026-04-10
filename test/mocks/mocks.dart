import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:file_uploader/core/network/network_caller.dart';
import 'package:file_uploader/core/storage/storage_service.dart';
import 'package:file_uploader/features/auth/repository/auth_repository.dart';
import 'package:file_uploader/features/home/repository/home_repository.dart';

// Use GetxService for the mock to satisfy GetX internal lifecycle calls
class MockNetworkCaller extends Mock implements NetworkCaller {}

class MockStorageService extends GetxService with Mock implements StorageService {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockHomeRepository extends Mock implements HomeRepository {}
