import '../config/env_config.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl => EnvConfig.baseUrl;

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static String get refreshToken => '$baseUrl/auth/refresh';
  static String get loginEndpoint => '$baseUrl/auth/login';
  static String get logoutEndpoint => '$baseUrl/auth/logout';
}
