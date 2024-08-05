import 'package:books_api/app/utils/service_locator.dart';
import 'package:books_api/config/app.dart';
import 'package:vania/vania.dart';

void main() async {
  setupLocator();
  Application().initialize(config: config);
}
