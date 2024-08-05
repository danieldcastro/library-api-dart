import 'dart:io';

import 'package:vania/vania.dart';

import '../../models/error_model.dart';

class BookMiddleware extends Middleware {
  @override
  Future<void> handle(Request req) async {
    if (req.response.statusCode == HttpStatus.badRequest) {
      req.response.write(
          ErrorModel(message: 'ISBN Inválido', type: 'BadRequestError')
              .toMap());
    }
  }
}
