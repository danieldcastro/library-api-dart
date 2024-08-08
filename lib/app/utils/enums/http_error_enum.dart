import 'dart:io';

import '../exceptions/my_sql_exceptions/my_sql_error.dart';

enum HttpErrorEnum {
  badRequest(HttpStatus.badRequest, 'Bad Request'),
  notFound(HttpStatus.notFound, 'Not Found'),
  internalServerError(HttpStatus.internalServerError, 'Internal Server Error'),
  unauthorized(HttpStatus.unauthorized, 'Unauthorized'),
  forbidden(HttpStatus.forbidden, 'Forbidden'),
  conflict(HttpStatus.conflict, 'Conflict'),
  unprocessableEntity(HttpStatus.unprocessableEntity, 'Unprocessable Entity'),
  tooManyRequests(HttpStatus.tooManyRequests, 'Too Many Requests'),
  serviceUnavailable(HttpStatus.serviceUnavailable, 'Service Unavailable'),
  requestTimeout(HttpStatus.requestTimeout, 'Request Timeout'),
  unknown(0, 'Unknown'),
  ;

  final int statusCode;
  final String type;

  const HttpErrorEnum(
    this.statusCode,
    this.type,
  );

  static HttpErrorEnum fromStatusCode(int statusCode) {
    return HttpErrorEnum.values.firstWhere(
      (element) => element.statusCode == statusCode,
      orElse: () => HttpErrorEnum.unknown,
    );
  }

  static HttpErrorEnum fromMySqlError(MySqlError error) => switch (error.code) {
        1062 => HttpErrorEnum.conflict,
        1049 => HttpErrorEnum.internalServerError,
        1146 => HttpErrorEnum.internalServerError,
        1451 => HttpErrorEnum.badRequest,
        1452 => HttpErrorEnum.badRequest,
        1136 => HttpErrorEnum.badRequest,
        1064 => HttpErrorEnum.badRequest,
        1205 => HttpErrorEnum.requestTimeout,
        _ => HttpErrorEnum.internalServerError,
      };
}
