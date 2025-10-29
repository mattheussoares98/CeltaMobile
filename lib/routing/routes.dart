enum Routes {
  auth('Autenticação'),
  adjustSalePrice('Alterar preços'),
  adjustSalePriceProducts('Alterar preços'),
  adjustStocks('Ajustar estoque'),
  buyQuotations('Cotação de compras'),
  buyRequest('Pedido de compras'),
  createEnterprise('Criar empresa'),
  customerRegister('Cadastro de clientes'),
  enterpriseManager('Gerenciamento de empresas'),
  enterpriseManagerAuth('Autenticação'),
  enterpriseManagerChangeModulesPermissions('Permissões de módulos'),
  enterpriseManagerDash('Dashboard'),
  enterprises('Empresas'),
  expeditionConferenceDocuments('Expedição (conferência)'),
  expeditionConferenceProducts('Conferência (expedição) produtos'),
  inventoryCountings('Contagens'),
  inventoryFrozenProcesses('Inventário'),
  inventoryProducts('Inventário (produtos)'),
  home('Home'),
  saleRequest('Pedido de vendas'),
  saleRequestRequestsTypes('Pedido de vendas'),
  searchProducts('Pesquisar produtos'),
  splash('Splash'),
  transferRequestDestinyEnterprises('Empresas de destino'),
  transferRequestOriginEnterprises('Empresas de origem'),
  transferRequestProductsManagement('Manuseio de produtos'),
  transferRequestRequestsTypes('Pedido de transferência'),
  transferBetweenStocks('Transferência entre estoques');

  final String module;
  const Routes(this.module);
}
