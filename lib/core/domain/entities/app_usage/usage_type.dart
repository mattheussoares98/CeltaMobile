enum UsageType {
  adjustSalePrice('Ajustou preço'),
  adjustStock('Ajustou estoque'),
  countInventoryProduct('Contou produto (inventário)'),
  countReceiptProduct('Contou produto (recebimento)'),
  downloadReport('Baixou relatório'),
  finishedExpedition('Finalizou expedição'),
  generateReport('Gerou relatório'),
  insertBuyRequest('Inseriu pedido de compra'),
  insertNotFoundReceiptProduct('Inseriu produto não encontrado (recebimento)'),
  insertSaleRequest('Inseriu pedido de venda'),
  insertTransferRequest('Inseriu pedido de transferência'),
  insertUpdateBuyQuotation('Inseriu/atualizou cotação de compra'),
  insertUpdateCustomer('Inseriu/atualizou cliente'),
  insertUpdateCompetingPrices('Atualizou preços concorrentes'),
  liberateReceiptDocument('Liberou recebimento'),
  searchProducts('Pesquisou produtos'),
  sendToPrint('Marcou p/ impressão'),
  stockReplacement('Substituiu estoque'),
  transferBetweenStocks('Transferiu entre estoques');

  final String description;
  const UsageType(this.description);
}
