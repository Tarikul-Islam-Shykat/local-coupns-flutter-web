extension StringFormatX on String {
  String toReadable() => toLowerCase()
      .replaceAll('_', ' ')
      .replaceFirstMapped(RegExp(r'^\w'), (m) => m[0]!.toUpperCase());
}
