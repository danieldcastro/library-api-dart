import 'package:vania/vania.dart';

class CreateUsersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      id();
      string('name', length: 100, comment: 'Nome do usuário');
      string('password', length: 255, comment: 'Senha do usuário');
      string('email', length: 100, comment: 'Email do usuário');
      timeStamps();
    });

    await MigrationConnection().dbConnection?.execute('''
      ALTER TABLE `users`
      ADD CONSTRAINT unique_email UNIQUE (email);
    ''');
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('users');
  }
}
