enum BSFPrintLabelAddressType {
  principal('Principal'),
  collection('Collection'),
  delivery('Delivery'),
  notApplicable('NotApplicable');

  final String apiValue;

  const BSFPrintLabelAddressType(this.apiValue);

  factory BSFPrintLabelAddressType.fromJson(Object? value) => values.firstWhere(
    (type) => type.apiValue == value,
    orElse: () => throw FormatException('Invalid label address type', value),
  );

  String toJson() => apiValue;
}
