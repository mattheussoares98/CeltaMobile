enum Modules {
  adjustPrice('Alterar preços'),
  adjustStock('Ajustar estoque'),
  buyQuotation('Cotação de compras'),
  buyRequest('Pedido de compras'),
  competingPrices('Preços concorrentes'),
  customerRegister('Cadastro de clientes'),
  expeditionConference('Expedição (conferência)'),
  inventory('Inventário'),
  receipt('Recebimento'),
  reports('Relatórios'),
  saleRequest('Pedido de vendas'),
  searchProducts('Pesquisar produtos'),
  stockReplacement('Substituição de estoque'),
  transferBetweenStocks('Transferência (estoques)'),
  transferRequest('Pedido de transferência');

  final String description;
  const Modules(this.description);
}
