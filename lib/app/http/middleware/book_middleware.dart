import 'dart:io';

import 'package:vania/vania.dart';

import '../../models/error_model.dart';
import '../../utils/enums/error_type_enum.dart';
import '../../utils/extensions/string_extensions.dart';

class BookMiddleware extends Middleware {
  @override
  Future<void> handle(Request req) async {
    final String isbn = req.input('isbn').toString();
    final isValidIsbn =
        isbn.hasOnlyNumbers && (isbn.length == 10 || isbn.length == 13);

    if (!isValidIsbn) {
      // req.response.write(ErrorModel.fromErrorType(
      //         ErrorTypeEnum.fromStatusCode(HttpStatus.badRequest),
      //         'ISBN Inválidosssss')
      //     .toMap());
      throw HttpResponseException(
        message: ErrorModel.fromErrorType(
                ErrorTypeEnum.fromStatusCode(HttpStatus.badRequest),
                'ISBN Inválido')
            .toMap(),
        code: HttpStatus.badRequest,
        responseType: ResponseType.json,
      );

      // return;
    }
  }
}
