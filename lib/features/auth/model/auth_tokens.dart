/// The token triple returned by the auth endpoints.
///
/// Parsing lives here rather than in the controller so that a malformed
/// response fails loudly at the network boundary with a clear message, instead
/// of throwing an opaque cast error somewhere deeper in the app.
class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    final accessToken = json['access_token'];
    final refreshToken = json['refresh_token'];
    final expiresIn = json['expires_in'];

    if (accessToken is! String || accessToken.isEmpty) {
      throw const FormatException('Auth response is missing "access_token".');
    }
    if (refreshToken is! String || refreshToken.isEmpty) {
      throw const FormatException('Auth response is missing "refresh_token".');
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: switch (expiresIn) {
        final int value => value,
        final String value => int.tryParse(value) ?? 0,
        _ => 0,
      },
    );
  }
}
