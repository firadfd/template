import 'app_error.dart';

/// A typed result of a network request.
///
/// [T] is the expected data type on success.
/// Use [isSuccess] to check status, [data] for the result, and [error] for failure info.
class ResponseData<T> {
  final bool isSuccess;
  final int statusCode;
  final T? data;
  final AppError? error;

  const ResponseData({
    required this.isSuccess,
    required this.statusCode,
    this.data,
    this.error,
  });

  // ─── Named constructors ───────────────────────────────────────────────────

  factory ResponseData.success({
    required int statusCode,
    T? data,
  }) {
    return ResponseData<T>(
      isSuccess: true,
      statusCode: statusCode,
      data: data,
    );
  }

  factory ResponseData.failure({
    required AppError error,
    int statusCode = 0,
  }) {
    return ResponseData<T>(
      isSuccess: false,
      statusCode: statusCode,
      error: error,
    );
  }

  // ─── Convenience getters ──────────────────────────────────────────────────

  /// Convenience getter matching old `responseData` usage for migration.
  /// Prefer accessing [data] directly in new code.
  T? get responseData => data;

  /// Shorthand for [error?.message].
  String get errorMessage => error?.message ?? '';

  // ─── Utilities ─────────────────────────────────────────────────────────────

  ResponseData<T> copyWith({
    bool? isSuccess,
    int? statusCode,
    T? data,
    AppError? error,
  }) {
    return ResponseData<T>(
      isSuccess: isSuccess ?? this.isSuccess,
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  /// Map this response to a different data type.
  ResponseData<R> mapData<R>(R Function(T data) mapper) {
    if (isSuccess && data != null) {
      return ResponseData<R>.success(statusCode: statusCode, data: mapper(data as T));
    }
    return ResponseData<R>.failure(error: error ?? AppError.unknown, statusCode: statusCode);
  }

  @override
  String toString() =>
      'ResponseData(isSuccess: $isSuccess, statusCode: $statusCode, error: $error)';
}
