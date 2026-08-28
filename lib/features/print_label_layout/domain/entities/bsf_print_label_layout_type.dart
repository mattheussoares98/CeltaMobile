enum BSFPrintLabelLayoutType {
  customer('Customer'),
  covenant('Covenant'),
  product('Product'),
  customerCard('CustomerCard'),
  saleBilling('SaleBilling'),
  transport('Transport'),
  saleRequestProduct('SaleRequestProduct');

  final String apiValue;

  const BSFPrintLabelLayoutType(this.apiValue);

  factory BSFPrintLabelLayoutType.fromJson(Object? value) => values.firstWhere(
    (type) => type.apiValue == value,
    orElse: () => throw FormatException('Invalid label layout type', value),
  );

  String toJson() => apiValue;
}
