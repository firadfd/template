enum Environment { dev, staging, prod }

/// Environment selection is compile-time, driven by `--dart-define`, so release
/// builds cannot accidentally ship pointing at a dev server:
///
/// ```bash
/// flutter run --dart-define=APP_ENV=dev
/// flutter build apk --release --dart-define=APP_ENV=prod \
///     --dart-define=API_BASE_URL=https://api.yourdomain.com
/// ```
class EnvConfig {
  EnvConfig._();

  static const String _envName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  /// Optional override. When set it wins over the per-environment defaults,
  /// which is handy for pointing a build at a review app or a local server.
  static const String _baseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static Environment get environment => switch (_envName) {
    'prod' => Environment.prod,
    'staging' => Environment.staging,
    _ => Environment.dev,
  };

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) return _baseUrlOverride;

    return switch (environment) {
      // TODO(you): replace these with your own API hosts.
      Environment.dev => 'https://dev.api.example.com',
      Environment.staging => 'https://staging.api.example.com',
      Environment.prod => 'https://api.example.com',
    };
  }

  static bool get isDev => environment == Environment.dev;
  static bool get isProd => environment == Environment.prod;

  static const bool _mockAuthFlag = bool.fromEnvironment('MOCK_AUTH');

  /// When true, [AuthRepository] issues fake tokens instead of calling the API,
  /// so you can run the app end-to-end before a backend exists. Any non-empty
  /// email and password is accepted.
  ///
  /// ```bash
  /// flutter run --dart-define=MOCK_AUTH=true
  /// ```
  ///
  /// Hard-disabled in prod so it can never be shipped, even if the define is
  /// left in a release command by mistake.
  static bool get useMockAuth => _mockAuthFlag && !isProd;
}
