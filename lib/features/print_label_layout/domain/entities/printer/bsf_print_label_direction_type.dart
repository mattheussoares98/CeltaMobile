enum BSFPrintLabelDirectionType {
  top('Top'),
  left('Left'),
  bottom('Bottom'),
  right('Right');

  final String apiValue;

  const BSFPrintLabelDirectionType(this.apiValue);

  factory BSFPrintLabelDirectionType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid label direction type', value),
      );

  String toJson() => apiValue;
}
