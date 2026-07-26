class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse.success(this.data, {this.statusCode = 200})
      : success = true,
        error = null;

  ApiResponse.error(this.error, {this.statusCode})
      : success = false,
        data = null;

  factory ApiResponse.fromResponse(int statusCode, dynamic data, String? error) {
    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse.success(data, statusCode: statusCode);
    } else {
      return ApiResponse.error(error ?? 'Request failed', statusCode: statusCode);
    }
  }
}
