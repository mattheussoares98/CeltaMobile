enum BSFPrintLabelFormType {
  paginated('Paginated'),
  continuous('Continuous');

  final String apiValue;

  const BSFPrintLabelFormType(this.apiValue);

  factory BSFPrintLabelFormType.fromJson(Object? value) => values.firstWhere(
    (type) => type.apiValue == value,
    orElse: () => throw FormatException('Invalid label form type', value),
  );

  String toJson() => apiValue;
}
