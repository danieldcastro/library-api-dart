import 'package:vania/vania.dart';

class CreateAuthorBooksTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('author_books', () {
      integer('author_id', comment: 'ID do autor');
      integer('book_id', comment: 'ID do livro');
      primary('author_books');
      foreign('book_id', 'books', 'id',
          constrained: true, onDelete: 'SET NULL');
      foreign('author_id', 'authors', 'id',
          constrained: true, onDelete: 'SET NULL');
      timeStamp('linked_at',
          comment: 'Data e hora em que o livro foi vinculado ao autor');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('author_books');
  }
}
