abstract class BaseMySqlException {
  final String message;
  final int? code;
  final String type;

  BaseMySqlException({required this.message, this.code, required this.type});
}
