class ErrorModel {
  final String message;
  final String type;

  ErrorModel({
    required this.message,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'type': type,
    };
  }
}
