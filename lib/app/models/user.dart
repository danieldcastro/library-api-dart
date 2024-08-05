import 'package:vania/vania.dart';

class User extends Model {
  final String? name;

  User({this.name}) {
    super.table('users');
  }
}
