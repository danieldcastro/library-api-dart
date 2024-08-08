import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/user_repository.dart';
import '../../models/user.dart';
import '../../utils/fp/either.dart';
import '../../utils/mixins/password_hash_mixin.dart';
import 'base_controller.dart';

class UserController extends BaseController with PasswordHashMixin {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  Future<Response> createUser(Request req) async {
    final user = User.fromJson(req.body);

    final result = await _userRepository.createAndReturn(user.toMap());

    return result.fold((error) {
      if (error.type.statusCode == HttpStatus.conflict) {
        return handleError(error.copyWith(message: 'Email já cadastrado.'));
      }
      return handleError(error);
    }, (success) async {
      final user = await _addHashPass(
        user: User.fromJson(success),
      );

      //TODO: Inserir os novos dados da senha no banco

      return Response.json(user.toFriendlyMap(), HttpStatus.created);
    });
  }

  Future<User> _addHashPass({required User user}) async {
    final pass = await hashPassword(user.password ?? '');

    return user.copyWith(
      password: pass.base64HashPass,
      salt: pass.base64Salt,
      parallelism: pass.parallelism,
      memorySize: pass.memorySize,
      iterations: pass.iterations,
    );
  }
}


 // final pass = await hashPassword(req.body['password']);

    // final isVerified =
    //     await verifyPassword(hashedPassword: pass, password: 'balbal');

    // print(isVerified);
