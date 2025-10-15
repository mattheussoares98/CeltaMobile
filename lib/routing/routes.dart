enum Routes {
  auth('Autenticação'),
  adjustSalePrice('Alterar preços'),
  adjustSalePriceProducts('Alterar preços'),
  adjustStocks('Ajustar estoque'),
  createEnterprise('Criar empresa'),
  customerRegister('Cadastro de clientes'),
  enterpriseManager('Gerenciamento de empresas'),
  enterpriseManagerAuth('Autenticação'),
  enterpriseManagerChangeModulesPermissions('Permissões de módulos'),
  enterpriseManagerDash('Dashboard'),
  enterprises('Empresas'),
  expeditionConferenceDocuments('Expedição (conferência)'),
  expeditionConferenceProducts('Conferência (expedição) produtos'),
  inventoryFrozenProcesses('Inventário'),
  home('Home'),
  searchProducts('Pesquisar produtos'),
  splash('Splash'),
  transferBetweenStocks('Transferência entre estoques');

  final String module;
  const Routes(this.module);
}
