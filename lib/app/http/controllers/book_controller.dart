import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/book_repository.dart';
import '../../models/error_model.dart';
import '../../utils/enums/error_type_enum.dart';
import '../../utils/fp/either.dart';

class BookController extends Controller {
  final BookRepository _bookRepository;

  BookController(this._bookRepository);

  Future<Response> getBookByIsbn(Object isbn) async {
    final result = await _bookRepository.getBookByIsbn(isbn.toString());

    return result.fold(
      (l) => Response.json(
          ErrorModel.fromErrorType(
                  ErrorTypeEnum.fromStatusCode(HttpStatus.badRequest),
                  'ISBN Inválido')
              .toMap(),
          HttpStatus.badRequest),
      (r) => Response.json(r.toMap()),
    );
  }
}
