import '../../models/book.dart';
import '../../models/error_model.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/fp/either.dart';
import '../datasource/isbn_brasil_api_datasource.dart';
import 'repository_template.dart';

class BookRepository extends RepositoryTemplate {
  final IsbnBrasilApiDatasource _apiDatasource;

  BookRepository(this._apiDatasource);

  @override
  Book createModelInstance() {
    return Book();
  }

  Future<Either<ErrorModel, Book>> _getBookByIsbnBrasilApi(String isbn) async {
    final result = await _apiDatasource.getBookByIsbn(isbn);
    return result.fold((error) {
      return Left(ErrorModel(
        type: HttpErrorEnum.notFound,
        message: 'Livro não encontrado',
      ));
    }, Right.new);
  }

  Future<Either<ErrorModel, Book>> getBookByIsbn(String isbn) async {
    final result = await getByParam(paramContent: isbn, paramName: 'isbn');

    return result.fold(
      (l) async {
        return await _getBookByIsbnBrasilApi(isbn);
      },
      (r) async {
        return Right(Book.fromJson(r));
      },
    );
  }
}
