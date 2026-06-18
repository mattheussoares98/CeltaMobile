enum UsageType {
  adjustCost('Ajustou custo'),
  adjustSalePrice('Ajustou preço'),
  adjustStock('Ajustou estoque'),
  completeSearchSaleRequest('Consulta COMPLETA de pedido de vendas'),
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
  notDefined('Não definido'),
  updateSaleRequest('Alterou pedido de vendas'),
  searchProducts('Pesquisou produtos'),
  sendToPrint('Marcou p/ impressão'),
  shallowSearchProduct('Consulta produtos (superficial)'),
  shallowSearchSaleRequest('Consulta SIMPLES de pedido de vendas'),
  stockReplacement('Substituiu estoque'),
  transferBetweenStocks('Transferiu entre estoques');

  final String description;
  const UsageType(this.description);
}
