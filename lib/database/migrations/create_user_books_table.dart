import 'package:vania/vania.dart';

class CreateUserBooksTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('user_books', () {
      bigInt('user_id', comment: 'ID do usuário', unsigned: true);
      bigInt('book_id', comment: 'ID do livro', unsigned: true);
      timeStamp('linked_at',
          comment: 'Data e hora em que o livro foi vinculado ao usuário');
    });

    await MigrationConnection().dbConnection?.execute('''
      ALTER TABLE `user_books`
      ADD PRIMARY KEY (`user_id`, `book_id`);

      ALTER TABLE `user_books`
      ADD CONSTRAINT `fk_user_book_id`
      FOREIGN KEY (`book_id`) REFERENCES `books` (`id`)
      ON DELETE CASCADE;

       ALTER TABLE `user_books`
      ADD CONSTRAINT `fk_user_id`
      FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
      ON DELETE CASCADE;
    ''');
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('user_books');
  }
}
