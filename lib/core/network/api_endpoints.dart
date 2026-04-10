class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  /// Replace with your actual refresh token endpoint.
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String loginEndpoint = '$baseUrl/auth/login';

  // ─── Home ─────────────────────────────────────────────────────────────────
  static const String posts = '$baseUrl/posts';
}
