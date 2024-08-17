import 'dart:io';

import 'package:vania/vania.dart';

import '../../models/error_model.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/mixins/auth_mixin.dart';

class BaseController extends Controller with AuthMixin {
  Response handleError(ErrorModel error) => switch (error.type) {
        HttpErrorEnum.badRequest =>
          Response.json(error.toMap(), HttpStatus.badRequest),
        HttpErrorEnum.conflict =>
          Response.json(error.toMap(), HttpStatus.conflict),
        HttpErrorEnum.internalServerError =>
          Response.json(error.toMap(), HttpStatus.internalServerError),
        HttpErrorEnum.notFound =>
          Response.json(error.toMap(), HttpStatus.notFound),
        HttpErrorEnum.unauthorized =>
          Response.json(error.toMap(), HttpStatus.unauthorized),
        HttpErrorEnum.forbidden =>
          Response.json(error.toMap(), HttpStatus.forbidden),
        HttpErrorEnum.unprocessableEntity =>
          Response.json(error.toMap(), HttpStatus.unprocessableEntity),
        HttpErrorEnum.tooManyRequests =>
          Response.json(error.toMap(), HttpStatus.tooManyRequests),
        HttpErrorEnum.serviceUnavailable =>
          Response.json(error.toMap(), HttpStatus.serviceUnavailable),
        HttpErrorEnum.requestTimeout =>
          Response.json(error.toMap(), HttpStatus.requestTimeout),
        HttpErrorEnum.unknown =>
          Response.json(error.toMap(), HttpStatus.internalServerError),
      };

  Response unprocessableEntity(String message) {
    return Response.json(
      ErrorModel(
        message: message,
        type: HttpErrorEnum.unprocessableEntity,
      ).toMap(),
      HttpStatus.unprocessableEntity,
    );
  }
}
