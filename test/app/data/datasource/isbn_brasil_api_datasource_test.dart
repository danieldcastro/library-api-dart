import 'package:books_api/app/data/datasource/isbn_brasil_api_datasource.dart';
import 'package:books_api/app/utils/fp/either.dart';
import 'package:test/test.dart';

void main() {
  late IsbnBrasilApiDatasource isbnBrasilApiDatasource;

  setUp(() {
    isbnBrasilApiDatasource = IsbnBrasilApiDatasource();
  });

  test('Should return a book by isbn', () async {
    const isbn = '9786500360677';
    final book = await isbnBrasilApiDatasource.getBookByIsbn(isbn);

    book.fold(
      Left.new,
      (r) {
        expect(r.title, 'Trauma Oculto');
        expect(r.authors, ['Daniel Marciano', 'Alan Vitalli']);
      },
    );
  });

  test('Should return a book by isbn with -', () async {
    const isbn = '978-65-0036067-7';
    final book = await isbnBrasilApiDatasource.getBookByIsbn(isbn);

    book.fold(
      Left.new,
      (r) {
        expect(r.title, 'Trauma Oculto');
        expect(r.authors, ['Daniel Marciano', 'Alan Vitalli']);
      },
    );
  });

  test('Should return a bad request', () async {
    const isbn = '978';
    final book = await isbnBrasilApiDatasource.getBookByIsbn(isbn);

    expect(book, isA<Left>());
  });
}
