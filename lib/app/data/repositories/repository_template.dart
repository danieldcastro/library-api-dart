import 'package:vania/vania.dart';

import '../../models/error_model.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/exceptions/my_sql_exceptions/my_sql_error.dart';
import '../../utils/fp/either.dart';

extension Teste on Map<String, dynamic> {
  Map<String, dynamic> get addTimestamps {
    this['created_at'] = DateTime.now().toIso8601String();
    this['updated_at'] = DateTime.now().toIso8601String();
    return this;
  }

  Map<String, dynamic> get addUpdatedAt {
    this['updated_at'] = DateTime.now().toIso8601String();
    return this;
  }
}

abstract class RepositoryTemplate<T extends Model> {
  Map<String, dynamic> _addTimeStamps(Map<String, dynamic> obj) {
    return obj.addTimestamps;
  }

  Map<String, dynamic> _addUpdatedAt(Map<String, dynamic> obj) {
    return obj.addUpdatedAt;
  }

  Future<Either<ErrorModel, Map<String, dynamic>>> createAndReturn(
      Map<String, dynamic> obj) async {
    try {
      T model = createModelInstance();
      return Right(await model.query().create(_addTimeStamps(obj)));
    } on Exception catch (e) {
      final error = MySqlError.handleError(e.toString());

      final HttpErrorEnum httpError = HttpErrorEnum.fromMySqlError(error);
      return Left(ErrorModel(type: httpError, message: error.message));
    }
  }

  Future<ErrorModel?> update(Map<String, dynamic> obj, int id) async {
    try {
      T model = createModelInstance();
      await model.query().where('id', '=', id).update(_addUpdatedAt(obj));
      return null;
    } on Exception catch (e) {
      final error = MySqlError.handleError(e.toString());

      final HttpErrorEnum httpError = HttpErrorEnum.fromMySqlError(error);
      return ErrorModel(type: httpError, message: error.message);
    }
  }

  Future<ErrorModel?> delete(int id) async {
    try {
      T model = createModelInstance();
      await model.query().delete(id);
      return null;
    } on Exception catch (e) {
      final error = MySqlError.handleError(e.toString());

      final HttpErrorEnum httpError = HttpErrorEnum.fromMySqlError(error);
      return ErrorModel(type: httpError, message: error.message);
    }
  }

  Future<Either<ErrorModel, Map<String, dynamic>>> get(int id) async {
    try {
      T model = createModelInstance();
      final data = await model.query().select().where('id', '=', id).first();

      if (data == null) {
        return Left(ErrorModel(
            type: HttpErrorEnum.notFound, message: 'Registro não encontrado'));
      }

      return Right(data);
    } on Exception catch (e) {
      final error = MySqlError.handleError(e.toString());

      final HttpErrorEnum httpError = HttpErrorEnum.fromMySqlError(error);
      return Left(ErrorModel(type: httpError, message: error.message));
    }
  }

  T createModelInstance();
}
