import 'package:vania/vania.dart';

import '../../app/http/controllers/book_controller.dart';
import '../../app/http/controllers/user_controller.dart';
import '../../app/http/middleware/user_middleware.dart';

class Version1 extends Route {
  final BookController _bookController;
  final UserController _userController;

  Version1(this._bookController, this._userController);

  @override
  void register() {
    Router.basePrefix('api/v1');

    Router.group(() {
      Router.get('{isbn}', _bookController.getBookByIsbn);
    }, prefix: 'isbn', middleware: [
      // BookMiddleware(),
    ]);

    Router.group(() {
      Router.post('/users', _userController.createUser);
    }, middleware: [
      UserMiddleware(),
    ]);
  }
}
