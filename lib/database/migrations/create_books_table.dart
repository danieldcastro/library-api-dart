import 'package:vania/vania.dart';

class CreateBooksTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('books', () {
      id();
      string(
        'isbn',
        length: 13,
        comment: 'ISBN do livro',
        nullable: true,
      );
      string(
        'title',
        length: 255,
        comment: 'Título do livro',
      );
      string(
        'subtitle',
        length: 255,
        comment: 'Subtítulo do livro',
        nullable: true,
      );
      string(
        'series',
        length: 255,
        comment: 'Série ou coleção do livro',
        nullable: true,
      );
      tinyInt(
        'volume',
        length: 3,
        comment: 'Volume do livro na série',
        nullable: true,
        unsigned: true,
      );
      string(
        'translator',
        length: 255,
        comment: 'Tradutor do livro',
        nullable: true,
      );
      string(
        'language',
        length: 50,
        comment: 'Idioma do livro',
      );
      string(
        'publisher',
        length: 255,
        comment: 'Editora do livro',
      );
      tinyInt(
        'edition',
        length: 3,
        comment: 'Edição do livro',
        unsigned: true,
      );
      year(
        'year',
        comment: 'Ano de publicação',
      );
      integer(
        'pages',
        length: 5,
        comment: 'Número de páginas',
        unsigned: true,
      );
      text(
        'synopsis',
        comment: 'Sinopse do livro',
      );
      string(
        'genres',
        length: 255,
        comment: 'Gêneros do livro (separados por vírgula)',
      );
      timeStamps();
    });

    await MigrationConnection().dbConnection?.execute('''
      ALTER TABLE `books`
      ADD CONSTRAINT unique_isbn UNIQUE (isbn);
    ''');
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('books');
  }
}
