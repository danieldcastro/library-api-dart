import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/book_repository.dart';
import '../../models/book.dart';
import '../../models/error_model.dart';
import '../../models/success_model.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/fp/either.dart';
import 'base_controller.dart';

class BookController extends BaseController {
  final BookRepository _bookRepository;

  BookController(this._bookRepository);

  Future<Response> getBookByIsbn(Object isbn) async {
    final String isbnFormatted = isbn.toString().replaceAll('-', '');

    if (!(isbnFormatted.length == 10) && !(isbnFormatted.length == 13)) {
      return handleError(
        ErrorModel(
          type: HttpErrorEnum.badRequest,
          message: 'ISBN inválido',
        ),
      );
    }

    final result = await _bookRepository.getBookByIsbn(isbnFormatted);

    return result.fold(
      handleError,
      (r) => Response.json(SuccessModel(data: r.toMap()).toMap()),
    );
  }

  Future<Response> createBook(Request req) async {
    final authCheck = await checkAuth(req);

    if (authCheck != null) {
      return authCheck;
    }

    final errorResponse = _validateCreateBookBody(req);
    if (errorResponse != null) {
      return errorResponse;
    }

    final book = Book.fromCreateRequestJson(req.body);
    final result = await _bookRepository.createAndReturn(book.toCreateMap());

    return result.fold(
      handleError,
      (r) => Response.json(SuccessModel(data: r).toMap(), HttpStatus.created),
    );
  }

  Response? _validateCreateBookBody(Request req) {
    try {
      req.validate({
        'isbn': 'min_length:10',
        'title': 'required',
        'language': 'required',
        'publisher': 'required',
        'edition': 'required',
        'year': 'required|min_length:4|max_length:4',
        'pages': 'required',
        'synopsis': 'required',
        'genres': 'required',
        'author_id': 'required',
      }, {
        'isbn.min_length': 'O campo isbn deve ter no mínimo 10 caracteres',
        'title.required': 'O campo título é obrigatório',
        'language.required': 'O campo idioma é obrigatório',
        'publisher.required': 'O campo editora é obrigatório',
        'edition.required': 'O campo edição é obrigatório',
        'year.required': 'O campo ano é obrigatório',
        'year.min_length': 'O campo ano deve ter 4 caracteres',
        'year.max_length': 'O campo ano deve ter 4 caracteres',
        'pages.required': 'O campo páginas é obrigatório',
        'synopsis.required': 'O campo sinopse é obrigatório',
        'genres.required': 'O campo gêneros é obrigatório',
      });
      return null;
    } catch (e) {
      final errorMessage =
          ((e as dynamic).message as Map<String, dynamic>).entries.first.value;
      return unprocessableEntity(errorMessage);
    }
  }
}
