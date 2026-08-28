enum BSFPrintLabelFieldImageExtensionType {
  notApplicable('NotApplicable'),
  bmp('Bmp'),
  dgi('Dgi'),
  img('Img');

  final String apiValue;

  const BSFPrintLabelFieldImageExtensionType(this.apiValue);

  factory BSFPrintLabelFieldImageExtensionType.fromJson(Object? value) =>
      values.firstWhere(
        (type) => type.apiValue == value,
        orElse: () =>
            throw FormatException('Invalid label image extension', value),
      );

  String toJson() => apiValue;
}
