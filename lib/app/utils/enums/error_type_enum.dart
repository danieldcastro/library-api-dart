import 'dart:io';

enum ErrorTypeEnum {
  badRequest(HttpStatus.badRequest, 'Bad Request'),
  notFound(HttpStatus.notFound, 'Not Found'),
  internalServerError(HttpStatus.internalServerError, 'Internal Server Error'),
  unauthorized(HttpStatus.unauthorized, 'Unauthorized'),
  forbidden(HttpStatus.forbidden, 'Forbidden'),
  conflict(HttpStatus.conflict, 'Conflict'),
  unprocessableEntity(HttpStatus.unprocessableEntity, 'Unprocessable Entity'),
  tooManyRequests(HttpStatus.tooManyRequests, 'Too Many Requests'),
  serviceUnavailable(HttpStatus.serviceUnavailable, 'Service Unavailable'),
  unknown(0, 'Unknown'),
  ;

  final int statusCode;
  final String type;

  const ErrorTypeEnum(
    this.statusCode,
    this.type,
  );

  static ErrorTypeEnum fromStatusCode(int statusCode) {
    return ErrorTypeEnum.values.firstWhere(
      (element) => element.statusCode == statusCode,
      orElse: () => ErrorTypeEnum.unknown,
    );
  }
}
