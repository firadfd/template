import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template/core/config/env_config.dart';
import 'package:template/core/network/app_error.dart';
import 'package:template/core/network/response_data.dart';
import 'package:template/features/auth/repository/auth_repository.dart';

import '../../mocks/mocks.dart';

void main() {
  late AuthRepository repository;
  late MockNetworkCaller mockNetworkCaller;

  void stubLogin(ResponseData<dynamic> response) {
    when(
      () => mockNetworkCaller.postRequest(
        any(),
        body: any(named: 'body'),
        isAuthCall: any(named: 'isAuthCall'),
      ),
    ).thenAnswer((_) async => response);
  }

  setUp(() {
    mockNetworkCaller = MockNetworkCaller();
    repository = AuthRepository(networkCaller: mockNetworkCaller);
  });

  group(
    'AuthRepository.login',
    skip: EnvConfig.useMockAuth ? 'mock auth bypasses the network layer' : null,
    () {
      test('maps a successful response to typed tokens', () async {
        stubLogin(
          ResponseData<dynamic>.success(
            statusCode: 200,
            data: const {
              'access_token': 'test_token',
              'refresh_token': 'test_refresh',
              'expires_in': 3600,
            },
          ),
        );

        final result = await repository.login(
          email: 'test@example.com',
          password: 'password',
        );

        expect(result.isSuccess, isTrue);
        expect(result.data?.accessToken, 'test_token');
        expect(result.data?.refreshToken, 'test_refresh');
        expect(result.data?.expiresIn, 3600);
      });

      test('propagates a network failure', () async {
        const errorMsg = 'Invalid credentials';
        stubLogin(
          ResponseData<dynamic>.failure(
            error: const AppError(message: errorMsg, statusCode: 401),
            statusCode: 401,
          ),
        );

        final result = await repository.login(
          email: 'wrong@example.com',
          password: 'wrong',
        );

        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, errorMsg);
      });

      test('turns a malformed success payload into a typed error', () async {
        stubLogin(
          ResponseData<dynamic>.success(
            statusCode: 200,
            data: const {'refresh_token': 'only_this_one'},
          ),
        );

        final result = await repository.login(
          email: 'test@example.com',
          password: 'password',
        );

        expect(result.isSuccess, isFalse);
        expect(result.error?.errorCode, 'MALFORMED_RESPONSE');
        expect(result.errorMessage, contains('access_token'));
      });
    },
  );

  group('mock auth', () {
    test('is off unless the MOCK_AUTH define is set', () {
      // Safety net: if this ever defaults to true, a release build could
      // ship an auth bypass. EnvConfig also ANDs it with !isProd.
      expect(const bool.fromEnvironment('MOCK_AUTH'), isFalse);
    }, skip: EnvConfig.useMockAuth ? 'MOCK_AUTH define is set' : null);

    test(
      'login issues fake tokens without touching the network',
      () async {
        final result = await repository.login(
          email: 'anything@example.com',
          password: 'anything',
        );

        expect(result.isSuccess, isTrue);
        expect(result.data?.accessToken, 'mock-access-token');
        verifyNever(
          () => mockNetworkCaller.postRequest(
            any(),
            body: any(named: 'body'),
            isAuthCall: any(named: 'isAuthCall'),
          ),
        );
      },
      skip: EnvConfig.useMockAuth
          ? false
          : 'run with --dart-define=MOCK_AUTH=true',
    );
  });
}
