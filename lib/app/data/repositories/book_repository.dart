import '../../models/book.dart';
import '../../utils/fp/either.dart';
import '../datasource/isbn_brasil_api_datasource.dart';

class BookRepository {
  final IsbnBrasilApiDatasource _apiDatasource;

  BookRepository(this._apiDatasource);

  Future<Either<Exception, Book>> getBookByIsbn(String isbn) async {
    return await _apiDatasource.getBookByIsbn(isbn);
  }
}
