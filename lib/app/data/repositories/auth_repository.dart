import 'package:vania/vania.dart';

import '../../models/error_model.dart';
import '../../models/user.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/exceptions/my_sql_exceptions/my_sql_error.dart';
import '../../utils/fp/either.dart';

class AuthRepository {
  Future<Either<ErrorModel, Map<String, dynamic>>> generateToken(
      User user) async {
    try {
      Map<String, dynamic> token = await Auth()
          .login(user.toMap())
          .createToken(expiresIn: Duration(hours: 24), withRefreshToken: true);
      return Right(token);
    } on Exception catch (e) {
      final error = MySqlError.handleError(e.toString());

      final HttpErrorEnum httpError = HttpErrorEnum.fromMySqlError(error);
      return Left(ErrorModel(type: httpError, message: error.message));
    }
  }
}
