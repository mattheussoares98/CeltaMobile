enum TransferJustificationType {
  adjustStock(3, 'Ajuste de estoque'),
  transferBetweenStocks(1, 'Transferência entre estoques');

  final int code;
  final String name;
  const TransferJustificationType(this.code, this.name);
}
