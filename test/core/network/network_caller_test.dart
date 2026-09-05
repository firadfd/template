import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template/core/network/network_caller.dart';

import '../../mocks/mocks.dart';

String _envelope(Map<String, dynamic> data) =>
    jsonEncode({'status': 'success', 'data': data});

void main() {
  late MockStorageService storage;

  setUp(() {
    storage = MockStorageService();

    when(() => storage.getAccessToken()).thenAnswer((_) async => 'stale-token');
    when(() => storage.getRefreshToken()).thenAnswer((_) async => 'refresh-me');
    when(() => storage.isAccessTokenExpired()).thenReturn(true);
    when(
      () => storage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
        expiresIn: any(named: 'expiresIn'),
      ),
    ).thenAnswer((_) async {});
  });

  group('token refresh', () {
    test(
      'concurrent requests on an expired token trigger exactly one refresh',
      () async {
        var refreshCalls = 0;

        final client = MockClient((request) async {
          if (request.url.path.endsWith('/auth/refresh')) {
            refreshCalls++;
            // Hold the refresh open so all five callers queue behind it.
            await Future<void>.delayed(const Duration(milliseconds: 50));
            return http.Response(
              _envelope({
                'access_token': 'fresh-token',
                'refresh_token': 'fresh-refresh',
                'expires_in': 3600,
              }),
              200,
            );
          }
          return http.Response(_envelope({'ok': true}), 200);
        });

        final caller = NetworkCaller(
          storage: storage,
          client: client,
          connectivityCheck: () async => true,
        );

        final responses = await Future.wait([
          for (var i = 0; i < 5; i++)
            caller.getRequest('https://example.test/items/$i'),
        ]);

        expect(responses.every((r) => r.isSuccess), isTrue);
        expect(
          refreshCalls,
          1,
          reason:
              'a rotating refresh token would be invalidated by parallel refreshes',
        );
      },
    );

    test('a later expiry starts a new refresh', () async {
      var refreshCalls = 0;

      final client = MockClient((request) async {
        if (request.url.path.endsWith('/auth/refresh')) {
          refreshCalls++;
          return http.Response(
            _envelope({
              'access_token': 'fresh-token',
              'refresh_token': 'fresh-refresh',
              'expires_in': 3600,
            }),
            200,
          );
        }
        return http.Response(_envelope({'ok': true}), 200);
      });

      final caller = NetworkCaller(
        storage: storage,
        client: client,
        connectivityCheck: () async => true,
      );

      await caller.getRequest('https://example.test/a');
      await caller.getRequest('https://example.test/b');

      expect(refreshCalls, 2);
    });
  });

  group('failure paths', () {
    test('returns NO_INTERNET without hitting the network', () async {
      var requests = 0;
      final client = MockClient((_) async {
        requests++;
        return http.Response('{}', 200);
      });

      final caller = NetworkCaller(
        storage: storage,
        client: client,
        connectivityCheck: () async => false,
      );

      final response = await caller.getRequest('https://example.test/items');

      expect(response.isSuccess, isFalse);
      expect(response.error?.errorCode, 'NO_INTERNET');
      expect(requests, 0);
    });

    test('maps a 404 to a typed NOT_FOUND error', () async {
      when(() => storage.isAccessTokenExpired()).thenReturn(false);

      final client = MockClient(
        (_) async => http.Response(jsonEncode({'message': 'Missing'}), 404),
      );

      final caller = NetworkCaller(
        storage: storage,
        client: client,
        connectivityCheck: () async => true,
      );

      final response = await caller.getRequest('https://example.test/nope');

      expect(response.isSuccess, isFalse);
      expect(response.statusCode, 404);
      expect(response.error?.errorCode, 'NOT_FOUND');
      expect(response.errorMessage, 'Missing');
    });
  });
}
