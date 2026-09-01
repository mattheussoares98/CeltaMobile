enum BSFPrintLabelLayoutType {
  customer('Customer', 'Cliente'),
  covenant('Covenant', 'Convênio'),
  product('Product', 'Produto'),
  customerCard('CustomerCard', 'Cartão de cliente'),
  saleBilling('SaleBilling', 'Faturamento'),
  transport('Transport', 'Transporte'),
  saleRequestProduct('SaleRequestProduct', 'Produto do pedido de venda');

  final String apiValue;
  final String label;

  const BSFPrintLabelLayoutType(this.apiValue, this.label);

  factory BSFPrintLabelLayoutType.fromJson(Object? value) => values.firstWhere(
    (type) => type.apiValue == value,
    orElse: () => throw FormatException('Invalid label layout type', value),
  );

  String toJson() => apiValue;
}
