import 'package:vania/vania.dart';

import '../../app/http/controllers/book_controller.dart';

class Version1 extends Route {
  final BookController _bookController;

  Version1(this._bookController);

  @override
  void register() {
    Router.basePrefix('api/v1');

    Router.group(() {
      Router.get('{isbn}', _bookController.getBookByIsbn);
    }, prefix: 'isbn', middleware: [
      // BookMiddleware(),
    ]);
  }
}
