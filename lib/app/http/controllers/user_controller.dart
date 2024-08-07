import 'package:vania/vania.dart';

import '../../data/repositories/user_repository.dart';

class UserController extends Controller {
  Future<Response> createUser(Request req) async {
    final user = req.body;
    final result = await UserRepository().createAndReturn(user);
    return Response.json(result);
  }
}
