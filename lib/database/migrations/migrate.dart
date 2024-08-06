import 'dart:io';

import 'package:vania/vania.dart';

import 'create_author_books_table.dart';
import 'create_authors_table.dart';
import 'create_books_table.dart';
import 'create_user_books_table.dart';
import 'create_users_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == 'migrate:fresh') {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  Future<void> registry() async {
    await CreateUsersTable().up();
    await CreateBooksTable().up();
    await CreateAuthorsTable().up();
    await CreateUserBooksTable().up();
    await CreateAuthorBooksTable().up();
  }

  Future<void> dropTables() async {
    await CreateAuthorsTable().down();
    await CreateBooksTable().down();
    await CreateUsersTable().down();
    await CreateAuthorBooksTable().down();
    await CreateUserBooksTable().down();
  }
}
