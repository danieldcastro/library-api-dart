import 'package:vania/vania.dart';

import '../../app/http/controllers/auth_controller.dart';
import '../../app/http/controllers/book_controller.dart';
import '../../app/http/controllers/user_controller.dart';

class Version1 extends Route {
  final BookController _bookController;
  final UserController _userController;
  final AuthController _authController;

  Version1(this._bookController, this._userController, this._authController);

  @override
  void register() {
    Router.basePrefix('api/v1');

    Router.group(() {
      Router.get('/isbn/{isbn}', _bookController.getBookByIsbn);
    }, prefix: 'books');

    Router.group(() {
      Router.post('/books', _bookController.createBook);
    });

    Router.group(() {
      Router.post('/users', _userController.createUser);
      Router.delete('/users/{id}', _userController.deleteUserById);
    }, middleware: [
      // UserMiddleware(),
    ]);

    Router.group(() {
      Router.post('/login', _authController.auth);
    }, prefix: 'auth');
  }
}
