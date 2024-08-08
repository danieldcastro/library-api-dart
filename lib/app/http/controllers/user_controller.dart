import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/user_repository.dart';
import '../../models/error_model.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/fp/either.dart';

class UserController extends Controller {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  Future<Response> createUser(Request req) async {
    final user = req.body;
    final result = await _userRepository.createAndReturn(user);

    return result.fold((error) {
      final HttpErrorEnum httpError = HttpErrorEnum.fromMySqlError(error);
      return switch (httpError) {
        HttpErrorEnum.conflict => Response.json(
            ErrorModel.fromErrorType(httpError, 'Email já cadastrado.').toMap(),
            httpError.statusCode),
        _ => Response.json(
            ErrorModel.fromErrorType(httpError, error.message).toMap(),
            httpError.statusCode)
      };
    },
        // ignore: unnecessary_lambdas
        (success) => Response.json(success, HttpStatus.created));
  }
}
