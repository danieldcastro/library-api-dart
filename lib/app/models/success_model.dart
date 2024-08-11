class SuccessModel {
  final Object? data;
  final String? message;

  SuccessModel({this.data, this.message});

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'message': message,
    };
  }
}
