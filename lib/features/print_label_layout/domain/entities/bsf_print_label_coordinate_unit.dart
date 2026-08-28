enum BSFPrintLabelCoordinateUnit {
  centimeter('Centimeter', 'Centímetros'),
  printerDot('PrinterDot', 'Pontos da impressora');

  final String apiValue;
  final String description;

  const BSFPrintLabelCoordinateUnit(this.apiValue, this.description);

  factory BSFPrintLabelCoordinateUnit.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid label coordinate unit', value),
      );

  String toJson() => apiValue;
}
