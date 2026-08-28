enum BSFPrintLabelFieldDimensionType {
  notApplicable('NotApplicable'),
  centimeter('Centimeter'),
  printerDot('PrinterDot'),
  scaleFactor('ScaleFactor'),
  printerCommandValue('PrinterCommandValue');

  final String apiValue;

  const BSFPrintLabelFieldDimensionType(this.apiValue);

  factory BSFPrintLabelFieldDimensionType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid label field dimension type', value),
      );

  String toJson() => apiValue;
}
