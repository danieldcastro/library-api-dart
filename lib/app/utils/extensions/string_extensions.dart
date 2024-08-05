extension StringExtensions on String {
  bool get hasOnlyNumbers => !contains(RegExp(r'[a-zA-Z]'));
}
