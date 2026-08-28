enum BSFPrintLabelCoordinateUnit {
  centimeter('Centimeter'),
  printerDot('PrinterDot');

  final String apiValue;

  const BSFPrintLabelCoordinateUnit(this.apiValue);

  factory BSFPrintLabelCoordinateUnit.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid label coordinate unit', value),
      );

  String toJson() => apiValue;
}
