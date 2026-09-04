enum BSFBarcodeSimbologyType {
  none('None'),
  code128('Code128'),
  interleaved2Of5('Interleaved2Of5'),
  ean('Ean'),
  qrCode('QrCode');

  final String apiValue;

  const BSFBarcodeSimbologyType(this.apiValue);

  factory BSFBarcodeSimbologyType.fromJson(Object? value) => values.firstWhere(
    (type) => type.apiValue == value,
    orElse: () => throw FormatException('Invalid barcode simbology', value),
  );

  String toJson() => apiValue;
}
