import 'package:vania/vania.dart';

class CreateAuthorsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('authors', () {
      id();
      string('name', length: 100, comment: 'Nome do autor');
      text('biography', comment: 'Biografia do autor');
      timeStamps();
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('authors');
  }
}
