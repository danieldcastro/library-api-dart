import 'package:vania/vania.dart';

class CreateUserBooksTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('user_books', () {
      integer('user_id', comment: 'ID do usuário');
      integer('book_id', comment: 'ID do livro');
      primary('user_id');
      foreign('book_id', 'books', 'id',
          constrained: true, onDelete: 'SET NULL');
      foreign('user_id', 'users', 'id',
          constrained: true, onDelete: 'SET NULL');
      timeStamp('linked_at',
          comment: 'Data e hora em que o livro foi vinculado ao usuário');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('user_books');
  }
}
