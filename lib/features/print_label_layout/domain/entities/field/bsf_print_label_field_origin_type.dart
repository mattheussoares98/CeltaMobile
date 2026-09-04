enum BSFPrintLabelFieldOriginType {
  userDefined('UserDefined'),
  celtaBSDefined('CeltaBSDefined');

  final String apiValue;

  const BSFPrintLabelFieldOriginType(this.apiValue);

  factory BSFPrintLabelFieldOriginType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid label field origin', value),
      );

  String toJson() => apiValue;
}
