enum BSFProductPackingSelectionType {
  onlyUnitary('OnlyUnitary', 'Unitário'),
  onlyMultiple('OnlyMultiple', 'Múltiplo'),
  both('Both', 'Ambos');

  final String apiValue;
  final String label;

  const BSFProductPackingSelectionType(this.apiValue, this.label);

  factory BSFProductPackingSelectionType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid product packing selection', value),
      );

  String toJson() => apiValue;
}
