enum BSFPrintLabelFieldType {
  string('String'),
  integer('Integer'),
  float('Float'),
  dateTime('DateTime'),
  barcode('Barcode'),
  logo('Logo'),
  boxOrLine('BoxOrLine');

  final String apiValue;

  const BSFPrintLabelFieldType(this.apiValue);

  factory BSFPrintLabelFieldType.fromJson(Object? value) => values.firstWhere(
    (type) => type.apiValue == value,
    orElse: () => throw FormatException('Invalid label field type', value),
  );

  String toJson() => apiValue;
}
