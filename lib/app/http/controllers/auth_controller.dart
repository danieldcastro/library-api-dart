import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../models/error_model.dart';
import '../../models/success_model.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/fp/either.dart';
import '../../utils/mixins/password_hash_mixin.dart';
import 'base_controller.dart';

class AuthController extends BaseController with PasswordHashMixin {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  AuthController(this._userRepository, this._authRepository);

  Response? _validateAuthBody(Request req) {
    try {
      req.validate({
        'email': 'required|email',
        'password': 'required|min_length:6',
      }, {
        'email.required': 'O campo email é obrigatório',
        'email.email': 'O campo email deve ser um email válido',
        'password.required': 'O campo senha é obrigatório',
        'password.min_length': 'O campo senha deve ter no mínimo 6 caracteres',
      });
      return null;
    } catch (e) {
      final errorMessage =
          ((e as dynamic).message as Map<String, dynamic>).entries.first.value;
      return Response.json(
        ErrorModel(
          message: errorMessage,
          type: HttpErrorEnum.unprocessableEntity,
        ).toMap(),
        HttpStatus.unprocessableEntity,
      );
    }
  }

  Future<Response> auth(Request req) async {
    final errorResponse = _validateAuthBody(req);

    if (errorResponse != null) {
      return errorResponse;
    }

    final body = req.body;
    final email = body['email'] as String?;
    final password = body['password'] as String?;

    final user = await _userRepository.getUserByEmail(email!);

    return user.fold(handleError, (success) async {
      final pass = await verifyPassword(
          password: password!, hashedPassword: Password.fromUser(success));

      if (!pass) {
        return Response.json(
            ErrorModel(
                    type: HttpErrorEnum.unauthorized, message: 'Senha inválida')
                .toMap(),
            HttpStatus.unauthorized);
      }
      final token = await _authRepository.generateToken(success);

      return token.fold(handleError, (token) {
        return Response.json(SuccessModel(data: token).toMap(), HttpStatus.ok);
      });
    });
  }
}
