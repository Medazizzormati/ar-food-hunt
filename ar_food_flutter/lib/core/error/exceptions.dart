abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(String message, {int? statusCode}) 
      : super(message, statusCode: statusCode);
}

class AuthException extends AppException {
  AuthException(String message, {int? statusCode = 401}) 
      : super(message, statusCode: statusCode);
}

class ServerException extends AppException {
  ServerException(String message, {int? statusCode = 500}) 
      : super(message, statusCode: statusCode);
}

class ValidationException extends AppException {
  ValidationException(String message, {int? statusCode = 400}) 
      : super(message, statusCode: statusCode);
}

class CacheException extends AppException {
  CacheException(String message) : super(message);
}
