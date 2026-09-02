enum BSFPrintLabelFieldDimensionType {
  notApplicable('NotApplicable', '', 1.0),
  centimeter('Centimeter', 'cm', 0.1),
  printerDot('PrinterDot', 'pontos', 1.0),
  scaleFactor('ScaleFactor', 'fator', 1.0),
  printerCommandValue('PrinterCommandValue', 'valor do comando', 1.0);

  final String apiValue;
  final String label;
  final double editorStep;

  const BSFPrintLabelFieldDimensionType(
    this.apiValue,
    this.label,
    this.editorStep,
  );

  String format(double value) => this == centimeter
      ? value.toStringAsFixed(1)
      : value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);

  factory BSFPrintLabelFieldDimensionType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid label field dimension type', value),
      );

  String toJson() => apiValue;
}
