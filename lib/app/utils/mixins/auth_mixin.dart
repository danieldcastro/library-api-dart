import 'dart:io';

import 'package:vania/vania.dart';

import '../../models/error_model.dart';
import '../enums/http_error_enum.dart';
import '../extensions/string_extensions.dart';

mixin AuthMixin {
  Future<Response?> checkAuth(Request req) async {
    final token = req.header('authorization')?.replaceFirst('Bearer ', '');

    if (token.isNullOrEmpty) {
      return Response.json(
        ErrorModel(
          message: 'Token não fornecido',
          type: HttpErrorEnum.unauthorized,
        ).toMap(),
        HttpStatus.unauthorized,
      );
    }

    try {
      await Auth().check(token!);
      return null;
    } catch (e) {
      return Response.json(
        ErrorModel(
          message: 'Não autorizado',
          type: HttpErrorEnum.unauthorized,
        ).toMap(),
        HttpStatus.unauthorized,
      );
    }
  }
}
