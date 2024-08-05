import 'package:vania/vania.dart';

import '../app/utils/service_locator.dart';
import 'version/version1.dart';

class ApiRoute implements Route {
  @override
  void register() {
    getIt<Version1>().register();

    // // Return error code 400
    // Router.get('wrong-request',
    //         () => Response.json({'message': 'Hi wrong request'}))
    //     .middleware([ErrorResponseMiddleware()]);

    // // Return Authenticated user data
    // Router.get("/user", () {
    //   return Response.json(Auth().user());
    // }).middleware([AuthenticateMiddleware()]);
  }
}
