class ExternalException implements Exception {
  final String message;

  ExternalException(this.message);

  @override
  String toString() => message;
}
