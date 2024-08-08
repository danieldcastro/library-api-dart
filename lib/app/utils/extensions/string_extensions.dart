extension StringExtensions on String {
  bool get hasOnlyNumbers => !contains(RegExp(r'[a-zA-Z]'));
}

extension NilStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
