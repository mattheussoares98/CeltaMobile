enum BSFProductPackingSelectionType {
  onlyUnitary('OnlyUnitary'),
  onlyMultiple('OnlyMultiple'),
  both('Both');

  final String apiValue;

  const BSFProductPackingSelectionType(this.apiValue);

  factory BSFProductPackingSelectionType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid product packing selection', value),
      );

  String toJson() => apiValue;
}
