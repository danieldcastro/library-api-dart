import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/book_repository.dart';
import '../../utils/fp/either.dart';

class BookController extends Controller {
  final BookRepository _bookRepository;

  BookController(this._bookRepository);

  Future<Response> getBookByIsbn(Object isbn) async {
    final result = await _bookRepository.getBookByIsbn(isbn.toString());

    return result.fold(
      (l) => Response.json({'error': 'ISBN Inválido'}, HttpStatus.badRequest),
      (r) => Response.json(r.toMap()),
    );
  }
}
