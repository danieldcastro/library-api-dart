import 'package:vania/vania.dart';

class CreateUsersTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('users', () {
      id();
      string('name', length: 100, comment: 'Nome do usuário');
      string('email', length: 100, comment: 'Email do usuário');
      string('password',
          length: 255,
          comment: 'hash da senha do usuário em base64',
          nullable: true);
      string('salt',
          length: 255,
          comment: 'Salt da senha do usuário em base64',
          nullable: true);
      integer('parallelism',
          comment: 'Paralelismo da senha do usuário', nullable: true);
      integer('memory_size',
          comment: 'Tamanho da memória da senha do usuário', nullable: true);
      integer('iterations',
          comment: 'Iterações da senha do usuário', nullable: true);
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
