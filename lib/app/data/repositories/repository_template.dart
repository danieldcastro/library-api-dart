import 'package:vania/vania.dart';

import '../../utils/exceptions/my_sql_exceptions/my_sql_error.dart';
import '../../utils/fp/either.dart';

extension Teste on Map<String, dynamic> {
  Map<String, dynamic> get addTimestamps {
    this['created_at'] = DateTime.now().toIso8601String();
    this['updated_at'] = DateTime.now().toIso8601String();
    return this;
  }
}

abstract class RepositoryTemplate<T extends Model> {
  Map<String, dynamic> _addTimeStamps(Map<String, dynamic> obj) {
    return obj.addTimestamps;
  }

  Future<Either<MySqlError, Map<String, dynamic>>> createAndReturn(
      Map<String, dynamic> obj) async {
    try {
      T model = createModelInstance();
      return Right(await model.query().create(_addTimeStamps(obj)));
    } on Exception catch (e) {
      return Left(MySqlError.handleError(e.toString()));
    }
  }

  T createModelInstance();
}
