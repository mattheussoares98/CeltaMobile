enum BSFPrintElementRotationType {
  none('None', '0°'),
  rotate90('Rotate90', '90°'),
  rotate180('Rotate180', '180°'),
  rotate270('Rotate270', '270°');

  final String apiValue;
  final String name;

  const BSFPrintElementRotationType(this.apiValue, this.name);

  factory BSFPrintElementRotationType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () => throw FormatException('Invalid print rotation', value),
      );

  String toJson() => apiValue;
}
