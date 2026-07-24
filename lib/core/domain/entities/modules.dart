enum Modules {
  adjustCost('Ajuste de custos'),
  adjustPrice('Alterar preços'),
  adjustStock('Ajustar estoque'),
  buyQuotation('Cotação de compras'),
  buyRequest('Pedido de compras'),
  buyMovement('Consulta de compras'),
  competingPrices('Preços concorrentes'),
  customerRegister('Cadastro de clientes'),
  expeditionConference('Expedição (conferência)'),
  inventory('Inventário'),
  processAuthorization('Autorização de processos'),
  productsRegister('Cadastro de produtos'),
  receipt('Recebimento'),
  reports('Relatórios'),
  saleRequest('Pedido de vendas'),
  searchProducts('Pesquisar produtos'),
  synchronizer('Sincronizador'),
  stockReplacement('Substituição de estoque'),
  transferBetweenStocks('Transferência (estoques)'),
  transferRequest('Pedido de transferência');

  final String description;
  const Modules(this.description);
}
