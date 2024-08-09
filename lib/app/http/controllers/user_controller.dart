import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/user_repository.dart';
import '../../models/error_model.dart';
import '../../models/user.dart';
import '../../utils/fp/either.dart';
import '../../utils/mixins/password_hash_mixin.dart';
import 'base_controller.dart';

class UserController extends BaseController with PasswordHashMixin {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  Future<Response> createUser(Request req) async {
    User user = User.fromJson(req.body);

    final result =
        await _userRepository.createAndReturn(user.toMap()..remove('password'));

    return result.fold((error) {
      if (error.type.statusCode == HttpStatus.conflict) {
        return handleError(error.copyWith(message: 'Email já cadastrado.'));
      }
      return handleError(error);
    }, (success) async {
      user = user.copyWith(id: success['id'] as int?);
      final updateResult = await updateUser(user);

      if (updateResult != null) {
        await deleteUser(user.id!);

        return handleError(updateResult);
      }
      return Response.json(user.toFriendlyMap(), HttpStatus.created);
    });
  }

  Future<ErrorModel?> updateUser(User user) async {
    final updatedUser = await _addHashPass(user: user);
    return await _userRepository.update(updatedUser, user.id!);
  }

  Future<ErrorModel?> deleteUser(int id) async {
    final result = await _userRepository.delete(id);

    return result;
  }

  Future<Map<String, dynamic>> _addHashPass({required User user}) async {
    final pass = await hashPassword(user.password ?? '');

    return {
      'password': pass.base64HashPass,
      'salt': pass.base64Salt,
      'parallelism': pass.parallelism,
      'memory_size': pass.memorySize,
      'iterations': pass.iterations,
    };
  }
}


 // final pass = await hashPassword(req.body['password']);

    // final isVerified =
    //     await verifyPassword(hashedPassword: pass, password: 'balbal');

    // print(isVerified);
