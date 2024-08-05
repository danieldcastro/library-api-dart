import 'dart:io';

import 'package:vania/vania.dart';

import 'create_user_table.dart';
import 'create_users_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == 'migrate:fresh') {
    Migrate().dropTables();
  } else {
    Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  Future<void> registry() async {
    await MigrationConnection().setup();
    await CreateUserTable().up();
    await CreateUserTable().up();
    await CreateUsersTable().up();
  }

  Future<void> dropTables() async {
    await CreateUsersTable().down();
    await CreateUserTable().down();
    await CreateUserTable().down();
  }
}
