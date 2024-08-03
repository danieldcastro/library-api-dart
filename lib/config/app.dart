import 'package:books_api/app/providers/route_service_provider.dart';
import 'package:vania/vania.dart';

import 'auth.dart';
import 'cors.dart';

Map<String, dynamic> config = {
  'name': env('APP_NAME'),
  'url': env('APP_URL'),
  'timezone': '',
  'cors': cors,
  'auth': authConfig,
  'providers': <ServiceProvider>[
    RouteServiceProvider(),
  ],
};
