class AppException implements Exception {
  final String? _message;
  // final String? _prefix;

  AppException([
    this._message,
    // this._prefix,
  ]);

  @override
  String toString() {
    // return '$_prefix$_message';
    return '$_message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message ?? 'No internet. Check your connection and retry.');
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(message ?? "Invalid request. Check your input and try again.");
}

class InvalidMethodException extends AppException {
  InvalidMethodException([String? message])
      : super(message ?? 'Action not allowed. Try again or contact support.');
}

class RequestTimeoutException extends AppException {
  RequestTimeoutException([String? message])
      : super(message ?? 'Request timed out. Check your connection.');
}

class TooManyRequestsException extends AppException {
  TooManyRequestsException([String? message])
      : super(message ?? 'Too many requests. Please wait and try again.');
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message])
      : super(message ?? 'Something went wrong. Try again later.');
}

class BadGatewayException extends AppException {
  BadGatewayException([String? message])
      : super(message ?? 'Connection issue. Please try again later.');
}

class ServiceUnavailableException extends AppException {
  ServiceUnavailableException([String? message])
      : super(message ?? 'Service unavailable. Please try again later.');
}

class GatewayTimeoutException extends AppException {
  GatewayTimeoutException([String? message])
      : super(message ?? 'Gateway timeout. Please try again later.');
}
