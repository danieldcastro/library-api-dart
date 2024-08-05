import 'dart:convert';

import '../utils/enums/error_type_enum.dart';

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

  String toJson() {
    return jsonEncode(toMap());
  }

  factory ErrorModel.fromErrorType(ErrorTypeEnum errorType, String message) =>
      ErrorModel(
        message: message,
        type: errorType.type,
      );
}
