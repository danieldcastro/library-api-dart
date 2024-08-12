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
}
