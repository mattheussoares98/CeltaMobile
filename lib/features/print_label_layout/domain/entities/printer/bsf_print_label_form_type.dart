enum BSFPrintLabelFormType {
  paginated('Paginated', 'Paginado'),
  continuous('Continuous', 'Contínuo');

  final String apiValue;
  final String description;

  const BSFPrintLabelFormType(this.apiValue, this.description);

  factory BSFPrintLabelFormType.fromJson(Object? value) => values.firstWhere(
    (type) => type.apiValue == value,
    orElse: () => throw FormatException('Invalid label form type', value),
  );

  String toJson() => apiValue;
}
