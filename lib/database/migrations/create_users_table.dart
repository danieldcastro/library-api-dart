import 'package:vania/vania.dart';

class CreateUsersTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('users', () {
      id();
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
