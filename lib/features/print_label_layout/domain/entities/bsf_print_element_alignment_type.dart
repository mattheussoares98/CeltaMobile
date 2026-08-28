enum BSFPrintElementAlignmentType {
  left('Left'),
  middle('Middle'),
  right('Right');

  final String apiValue;

  const BSFPrintElementAlignmentType(this.apiValue);

  factory BSFPrintElementAlignmentType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () => throw FormatException('Invalid print alignment', value),
      );

  String toJson() => apiValue;
}
