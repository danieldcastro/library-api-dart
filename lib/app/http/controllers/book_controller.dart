import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/book_repository.dart';
import '../../models/error_model.dart';
import '../../models/success_model.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/fp/either.dart';
import 'base_controller.dart';

class BookController extends BaseController {
  final BookRepository _bookRepository;

  BookController(this._bookRepository);

  Future<Response> getBookByIsbn(Object isbn) async {
    final result = await _bookRepository.getBookByIsbn(isbn.toString());

    return result.fold(
      (l) => Response.json(
          ErrorModel(
                  type: HttpErrorEnum.fromStatusCode(HttpStatus.badRequest),
                  message: 'ISBN Inválido')
              .toMap(),
          HttpStatus.badRequest),
      (r) => Response.json(SuccessModel(data: r).toMap()),
    );
  }
}
