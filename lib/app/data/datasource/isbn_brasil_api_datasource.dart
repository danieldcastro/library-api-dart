import 'package:dio/dio.dart';

import '../../models/book.dart';
import '../../utils/exceptions/exceptions.dart';
import '../../utils/fp/either.dart';

class IsbnBrasilApiDatasource {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://brasilapi.com.br/api/isbn/v1',
    ),
  );

  Future<Either<Exception, Book>> getBookByIsbn(String isbn) async {
    try {
      final Response(:Map<String, dynamic> data) = await _dio.get('/$isbn');
      return Right(Book.fromJson(data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return Left(ExternalException(e.response?.data['message']));
      }
      return Left(Exception('Internal server error'));
    }
  }
}
