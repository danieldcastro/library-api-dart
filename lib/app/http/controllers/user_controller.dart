import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/user_repository.dart';
import '../../models/error_model.dart';
import '../../models/success_model.dart';
import '../../models/user.dart';
import '../../utils/enums/http_error_enum.dart';
import '../../utils/fp/either.dart';
import '../../utils/mixins/password_hash_mixin.dart';
import 'base_controller.dart';

class UserController extends BaseController with PasswordHashMixin {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  Response? _validateCreateUserBody(Request req) {
    try {
      req.validate({
        'name': 'required|min_length:3',
        'email': 'required|email',
        'password': 'required|min_length:6',
      }, {
        'name.required': 'O campo nome é obrigatório',
        'name.min_length': 'O campo nome deve ter no mínimo 3 caracteres',
        'email.required': 'O campo email é obrigatório',
        'email.email': 'O campo email deve ser um email válido',
        'password.required': 'O campo senha é obrigatório',
        'password.min_length': 'O campo senha deve ter no mínimo 6 caracteres',
      });
      return null;
    } catch (e) {
      final errorMessage =
          ((e as dynamic).message as Map<String, dynamic>).entries.first.value;
      return _unprocessableEntity(errorMessage);
    }
  }

  Future<Response> createUser(Request req) async {
    final errorResponse = _validateCreateUserBody(req);
    if (errorResponse != null) {
      return errorResponse;
    }

    User user = User.fromRequestJson(req.body);
    final result =
        await _userRepository.createAndReturn(user.toMapWithoutSensitiveData());

    return result.fold((error) {
      return error.type.statusCode == HttpStatus.conflict
          ? handleError(error.copyWith(message: 'Email já cadastrado.'))
          : handleError(error);
    }, (success) async {
      user = user.copyWith(id: success['id'] as int?);
      final updateResult = await updateUserPass(user);

      if (updateResult != null) {
        final deleteError = await _userRepository.delete(user.id!);
        if (deleteError != null) {
          return handleError(deleteError);
        }
        return handleError(updateResult);
      }
      return Response.json(
          SuccessModel(data: user.toFriendlyMap()).toMap(), HttpStatus.created);
    });
  }

  Future<ErrorModel?> updateUserPass(User user) async {
    final updatedUser = await _addHashPass(user: user);
    return _userRepository.update(updatedUser, user.id!);
  }

  Future<Map<String, dynamic>> _addHashPass({required User user}) async {
    final pass = await hashPassword(user.password ?? '');
    return pass.toMap();
  }

  Response _unprocessableEntity(String message) {
    return Response.json(
      ErrorModel(
        message: message,
        type: HttpErrorEnum.unprocessableEntity,
      ).toMap(),
      HttpStatus.unprocessableEntity,
    );
  }

  Future<Response?> deleteUserById(Request req, int id) async {
    final authCheck = await checkAuth(req);

    if (authCheck != null) {
      return authCheck;
    }

    final user = await _userRepository.getById(id);

    return user.fold(
        (error) =>
            handleError(error.copyWith(message: 'Usuário não encontrado')),
        (success) async {
      final resultError = await _userRepository.delete(id);
      if (resultError == null) {
        return Response.json(
            SuccessModel(message: 'Usuário deletado com sucesso').toMap(),
            HttpStatus.ok);
      }
      return handleError(resultError);
    });
  }
}

extension on User {
  Map<String, dynamic> toMapWithoutSensitiveData() {
    final map = toMap();
    map.remove('password');
    map.remove('id');
    return map;
  }
}

extension on Password {
  Map<String, dynamic> toMap() {
    return {
      'password': base64HashPass,
      'salt': base64Salt,
      'parallelism': parallelism,
      'memory_size': memorySize,
      'iterations': iterations,
    };
  }
}
