import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../models/error_model.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/fp/either.dart';
import '../../utils/mixins/password_hash_mixin.dart';
import 'base_controller.dart';

class AuthController extends BaseController with PasswordHashMixin {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  AuthController(this._userRepository, this._authRepository);

  Future<Response> auth(Request req) async {
    final body = req.body;
    final email = body['email'] as String?;
    final password = body['password'] as String?;

    if (email == null || password == null) {
      return Response.json(
          ErrorModel(
                  type: HttpErrorEnum.badRequest,
                  message: 'Email e senha são obrigatórios')
              .toMap(),
          HttpStatus.badRequest);
    }

    final user = await _userRepository.getUserByEmail(email);

    return user.fold(handleError, (success) async {
      final pass = await verifyPassword(
          password: password, hashedPassword: Password.fromUser(success));

      if (!pass) {
        return Response.json(
            ErrorModel(
                    type: HttpErrorEnum.unauthorized, message: 'Senha inválida')
                .toMap(),
            HttpStatus.unauthorized);
      }
      final token = await _authRepository.generateToken(success);

      return token.fold(handleError, (token) {
        return Response.json(token, HttpStatus.ok);
      });
    });
  }
}
