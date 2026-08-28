enum BSFPrintElementRotationType {
  none('None'),
  rotate90('Rotate90'),
  rotate180('Rotate180'),
  rotate270('Rotate270');

  final String apiValue;

  const BSFPrintElementRotationType(this.apiValue);

  factory BSFPrintElementRotationType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () => throw FormatException('Invalid print rotation', value),
      );

  String toJson() => apiValue;
}
