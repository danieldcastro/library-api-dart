import 'package:get_it/get_it.dart';

import '../../route/version/version1.dart';
import '../data/datasource/isbn_brasil_api_datasource.dart';
import '../data/repositories/book_repository.dart';
import '../data/repositories/user_repository.dart';
import '../http/controllers/book_controller.dart';
import '../http/controllers/user_controller.dart';

final getIt = GetIt.I;

void setupLocator() {
  getIt.registerFactory(IsbnBrasilApiDatasource.new);
  getIt.registerFactory(() => BookRepository(getIt()));
  getIt.registerFactory(() => BookController(getIt()));
  getIt.registerFactory(UserRepository.new);
  getIt.registerFactory(() => UserController(getIt()));
  getIt.registerFactory(() => Version1(getIt(), getIt()));
}
