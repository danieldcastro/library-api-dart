import 'dart:io';

import 'package:vania/vania.dart';

import '../../models/error_model.dart';
import '../../utils/enums/http_error_enum.dart';

class UserMiddleware extends Middleware {
  @override
  Future<ErrorModel?> handle(Request req) async {
    try {
      req.validate({
        'name': 'required',
        'email': 'required|email',
        'password': 'required|min_length:6',
      }, {
        'name.required': 'O campo nome é obrigatório',
        'email.required': 'O campo email é obrigatório',
        'email.email': 'O campo email deve ser um email válido',
        'password.required': 'O campo senha é obrigatório',
        'password.min': 'O campo senha deve ter no mínimo 6 caracteres',
      });
      return null;
    } catch (e) {
      throw CustomHttpException(
        statusCode: HttpStatus.unprocessableEntity,
        contentType: ContentType.json,
        responseBody: ErrorModel(
          message: 'O campo nome é obrigatório',
          type: HttpErrorEnum.unprocessableEntity,
        ).toMap(),
      );
      // if (e.toString().contains('ValidationException')) {
      //   Request.from(request: req.request).response
      //     ..statusCode =
      //         HttpStatus.unprocessableEntity // Define o status code 422
      //     ..headers.contentType = ContentType.json;
      //   return ErrorModel(
      //       message: 'O campo nome é obrigatório',
      //       type: HttpErrorEnum.unprocessableEntity);
      // } else {
      //   rethrow; // Se não for uma exceção de validação, rethrow
      // }
    }
    // return null;
  }
}

class CustomHttpException implements Exception {
  final int statusCode;
  final ContentType contentType;
  final Map<String, dynamic> responseBody;

  CustomHttpException({
    required this.statusCode,
    required this.contentType,
    required this.responseBody,
  });

  @override
  String toString() {
    return 'CustomHttpException: $statusCode - ${responseBody.toString()}';
  }
}
