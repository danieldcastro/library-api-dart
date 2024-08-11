import '../../models/error_model.dart';
import '../../models/user.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/exceptions/my_sql_exceptions/my_sql_error.dart';
import '../../utils/fp/either.dart';
import 'repository_template.dart';

class UserRepository extends RepositoryTemplate {
  @override
  User createModelInstance() {
    return User();
  }

  Future<Either<ErrorModel, User>> getUserByEmail(String email) async {
    try {
      final user = await User().query().where('email', '=', email).first();

      if (user == null) {
        return Left(ErrorModel(
            type: HttpErrorEnum.notFound, message: 'Usuário não encontrado'));
      }

      return Right(User.fromDbJson(user));
    } on Exception catch (e) {
      final error = MySqlError.handleError(e.toString());

      final HttpErrorEnum httpError = HttpErrorEnum.fromMySqlError(error);
      return Left(ErrorModel(type: httpError, message: error.message));
    }
  }
}
