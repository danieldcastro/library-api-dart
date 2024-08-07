import 'package:vania/vania.dart';

class CreateAuthorBooksTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('author_books', () {
      bigInt('author_id', comment: 'ID do autor', unsigned: true);
      bigInt('book_id', comment: 'ID do livro', unsigned: true);
      timeStamp('linked_at',
          comment: 'Data e hora em que o livro foi vinculado ao autor');
    });

    await MigrationConnection().dbConnection?.execute('''
      ALTER TABLE `author_books`
      ADD PRIMARY KEY (`author_id`, `book_id`);

      ALTER TABLE `author_books`
      ADD CONSTRAINT `fk_author_book_id`
      FOREIGN KEY (`book_id`) REFERENCES `books` (`id`)
      ON DELETE CASCADE;

      ALTER TABLE `author_books`
      ADD CONSTRAINT `fk_author_id`
      FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`)
      ON DELETE CASCADE;
    ''');
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('author_books');
  }
}
