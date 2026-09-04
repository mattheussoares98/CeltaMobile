enum BSFPrintElementAlignmentType {
  left('Left', 'Esquerda'),
  middle('Middle', 'Centro'),
  right('Right', 'Direita');

  final String apiValue;
  final String label;

  const BSFPrintElementAlignmentType(this.apiValue, this.label);

  factory BSFPrintElementAlignmentType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () => throw FormatException('Invalid print alignment', value),
      );

  String toJson() => apiValue;
}
