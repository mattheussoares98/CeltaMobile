enum BSFPrintLabelCoordinateUnit {
  centimeter('Centimeter', 'Centímetros', 'cm', 0.1),
  printerDot('PrinterDot', 'Pontos da impressora', 'pontos', 1.0);

  final String apiValue;
  final String description;
  final String label;
  final double editorStep;

  const BSFPrintLabelCoordinateUnit(
    this.apiValue,
    this.description,
    this.label,
    this.editorStep,
  );

  String format(double value) => this == centimeter
      ? value.toStringAsFixed(1)
      : value.truncateToDouble() == value
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);

  factory BSFPrintLabelCoordinateUnit.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid label coordinate unit', value),
      );

  String toJson() => apiValue;
}
