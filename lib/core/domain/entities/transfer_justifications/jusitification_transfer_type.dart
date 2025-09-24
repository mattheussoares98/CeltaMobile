enum JusitificationTransferType {
  adjustStock(3, 'Ajuste de estoque'),
  transferBetweenStocks(1, 'Transferência entre estoques');

  final int code;
  final String name;
  const JusitificationTransferType(this.code, this.name);
}
