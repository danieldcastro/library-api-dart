import 'dart:convert';

import '../utils/enums/http_error_enum.dart';

class ErrorModel {
  final String message;
  final HttpErrorEnum type;

  ErrorModel({
    required this.message,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'type': HttpErrorEnum.values[type.index].type,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  ErrorModel copyWith({
    String? message,
    HttpErrorEnum? type,
  }) {
    return ErrorModel(
      message: message ?? this.message,
      type: type ?? this.type,
    );
  }
}
