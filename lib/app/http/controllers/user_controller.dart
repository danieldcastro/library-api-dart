import 'dart:io';

import 'package:vania/vania.dart';

import '../../data/repositories/user_repository.dart';
import '../../utils/fp/either.dart';
import 'base_controller.dart';

class UserController extends BaseController {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  Future<Response> createUser(Request req) async {
    final user = req.body;
    final result = await _userRepository.createAndReturn(user);

    return result.fold((error) {
      if (error.type.statusCode == HttpStatus.conflict) {
        return handleError(error.copyWith(message: 'Email já cadastrado.'));
      }
      return handleError(error);
    }, (success) => Response.json(success, HttpStatus.created));
  }
}
