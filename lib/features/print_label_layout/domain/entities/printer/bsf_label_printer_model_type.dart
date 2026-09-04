enum BSFLabelPrinterModelType {
  generic('Generic'),
  zebraStripe('ZebraStripe'),
  eltron('Eltron'),
  rabbitOS214('RabbitOS214'),
  allegro('Allegro'),
  zebraGC420t('ZebraGC420t'),
  os214Plus('OS214PLUS');

  final String apiValue;

  const BSFLabelPrinterModelType(this.apiValue);

  factory BSFLabelPrinterModelType.fromJson(Object? value) => values.firstWhere(
    (type) => type.apiValue == value,
    orElse: () => throw FormatException('Invalid label printer model', value),
  );

  String toJson() => apiValue;
}
