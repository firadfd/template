/// Structured error model for network and application errors.
/// Replaces plain [String] error messages with typed, actionable error data.
class AppError {
  /// Human-readable error message for display.
  final String message;

  /// HTTP status code, if applicable.
  final int? statusCode;

  /// Machine-readable error code for conditional UI logic
  /// (e.g., 'INVALID_CREDENTIALS', 'TOKEN_EXPIRED', 'NO_INTERNET').
  final String? errorCode;

  const AppError({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  // ─── Pre-defined common errors ────────────────────────────────────────────

  static const AppError unknown = AppError(
    message: 'An unexpected error occurred.',
    errorCode: 'UNKNOWN',
  );

  static const AppError noInternet = AppError(
    message: 'No internet connection.',
    statusCode: 0,
    errorCode: 'NO_INTERNET',
  );

  static const AppError timeout = AppError(
    message: 'Request timed out. Please try again.',
    statusCode: 408,
    errorCode: 'TIMEOUT',
  );

  static const AppError unauthorized = AppError(
    message: 'Session expired. Please log in again.',
    statusCode: 401,
    errorCode: 'UNAUTHORIZED',
  );

  // ─── Factory ──────────────────────────────────────────────────────────────

  factory AppError.fromStatusCode(int statusCode, {String? message}) {
    switch (statusCode) {
      case 400:
        return AppError(message: message ?? 'Invalid request.', statusCode: 400, errorCode: 'BAD_REQUEST');
      case 401:
        return AppError(message: message ?? 'Unauthorized.', statusCode: 401, errorCode: 'UNAUTHORIZED');
      case 403:
        return AppError(message: message ?? 'Access denied.', statusCode: 403, errorCode: 'FORBIDDEN');
      case 404:
        return AppError(message: message ?? 'Resource not found.', statusCode: 404, errorCode: 'NOT_FOUND');
      case 408:
        return AppError.timeout;
      case 422:
        return AppError(message: message ?? 'Validation failed.', statusCode: 422, errorCode: 'VALIDATION');
      case 500:
        return AppError(message: message ?? 'Server error.', statusCode: 500, errorCode: 'SERVER_ERROR');
      default:
        return AppError(message: message ?? 'Request failed.', statusCode: statusCode, errorCode: 'HTTP_$statusCode');
    }
  }

  // ─── Utilities ────────────────────────────────────────────────────────────

  bool get isUnauthorized => errorCode == 'UNAUTHORIZED';
  bool get isNoInternet => errorCode == 'NO_INTERNET';
  bool get isTimeout => errorCode == 'TIMEOUT';

  AppError copyWith({String? message, int? statusCode, String? errorCode}) {
    return AppError(
      message: message ?? this.message,
      statusCode: statusCode ?? this.statusCode,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  String toString() => 'AppError(code: $errorCode, status: $statusCode, message: $message)';
}
