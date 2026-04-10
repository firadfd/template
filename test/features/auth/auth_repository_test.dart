import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:file_uploader/features/auth/repository/auth_repository.dart';
import 'package:file_uploader/core/network/response_data.dart';
import 'package:file_uploader/core/network/app_error.dart';
import '../../mocks/mocks.dart';

void main() {
  late AuthRepository repository;
  late MockNetworkCaller mockNetworkCaller;

  setUp(() {
    mockNetworkCaller = MockNetworkCaller();
    repository = AuthRepository(networkCaller: mockNetworkCaller);
  });

  group('AuthRepository Login Tests', () {
    test('login returns success when network caller returns success', () async {
      // Arrange
      final mockResponse = ResponseData.success(
        statusCode: 200,
        data: {
          'status': 'success',
          'data': {
            'access_token': 'test_token',
            'refresh_token': 'test_refresh',
            'expires_in': 3600,
          }
        },
      );

      when(() => mockNetworkCaller.postRequest(
            any(),
            body: any(named: 'body'),
            isAuthCall: any(named: 'isAuthCall'),
            showLoading: any(named: 'showLoading'),
            showSuccessMessage: any(named: 'showSuccessMessage'),
            showErrorMessage: any(named: 'showErrorMessage'),
          )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.login(email: 'test@example.com', password: 'password');

      // Assert
      expect(result.isSuccess, true);
      expect(result.data['data']['access_token'], 'test_token');
    });

    test('login returns failure when network caller returns error', () async {
      // Arrange
      final mockResponse = ResponseData.failure(
        error: const AppError(message: 'Invalid credentials', statusCode: 401),
      );

      when(() => mockNetworkCaller.postRequest(
            any(),
            body: any(named: 'body'),
            isAuthCall: any(named: 'isAuthCall'),
            showLoading: any(named: 'showLoading'),
            showSuccessMessage: any(named: 'showSuccessMessage'),
            showErrorMessage: any(named: 'showErrorMessage'),
          )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await repository.login(email: 'wrong@example.com', password: 'wrong');

      // Assert
      expect(result.isSuccess, false);
      expect(result.errorMessage, 'Invalid credentials');
    });
  });
}
