// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Celta mobile';

  @override
  String get language => 'Idioma';

  @override
  String get portuguese => 'Português';

  @override
  String get english => 'Inglês';

  @override
  String get signIn => 'Entrar';

  @override
  String get enterprise => 'Empresa';

  @override
  String get username => 'Usuário';

  @override
  String get password => 'Senha';

  @override
  String get requiredField => 'Campo obrigatório';

  @override
  String get error => 'Erro';

  @override
  String get showPassword => 'Mostrar senha';

  @override
  String get hidePassword => 'Ocultar senha';

  @override
  String get postalCode => 'CEP';

  @override
  String get searchPostalCode => 'Pesquisar CEP';

  @override
  String get state => 'Estado';

  @override
  String get reference => 'Referência';

  @override
  String get number => 'Número';

  @override
  String get district => 'Bairro';

  @override
  String get complement => 'Complemento';

  @override
  String get city => 'Cidade';

  @override
  String get street => 'Logradouro';

  @override
  String get address => 'Endereço';

  @override
  String get addAddress => 'Adicionar endereço';

  @override
  String get requestTemplates => 'Modelos de pedido';

  @override
  String get noRequestTemplates =>
      'Nenhum modelo de pedido foi encontrado\n\nLembre-se que somente modelos que estão com o parâmetro \"Permitir a utilização em pedidos feitos por aplicativos\" aparecerão aqui';

  @override
  String get reload => 'Carregar novamente';

  @override
  String get defaultTemplate => 'Modelo padrão';

  @override
  String get personalizedCode => 'Cód personalizado';

  @override
  String get code => 'Código';

  @override
  String get name => 'Nome';

  @override
  String get operationType => 'Tipo de operação';

  @override
  String get practicedPrice => 'Preço praticado';

  @override
  String get priceType => 'Tipo preço';

  @override
  String get canChangeCostOrSalePrice => 'Pode alterar preço de custo ou venda';

  @override
  String get cannotChangeCostOrSalePrice =>
      'Não pode alterar preço de custo ou venda';

  @override
  String get canChangePrice => 'Permite alterar o preço';

  @override
  String get cannotChangePrice => 'Não permite alterar o preço';

  @override
  String get canApplyManualDiscount => 'Permite desconto manual';

  @override
  String get cannotApplyManualDiscount => 'Não permite desconto manual';

  @override
  String get searchHint => 'Pesquisar...';

  @override
  String get search => 'Pesquisar';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Próximo';

  @override
  String get downloadAppPrompt => 'Faça o download do app para utilizar';

  @override
  String get download => 'Baixar';

  @override
  String get digitsOnly => 'Digite somente números';

  @override
  String get fieldTooShort => 'Campo muito curto';

  @override
  String get invalidCpf => 'CPF inválido';

  @override
  String get invalidCnpj => 'CNPJ inválido';

  @override
  String get invalidUrl => 'URL inválida';

  @override
  String get httpsRequired => 'A URL precisa ser HTTPS';

  @override
  String get invalidFormat => 'Formato inválido';

  @override
  String get integersOnly => 'Apenas números inteiros';

  @override
  String get greaterThanZero => 'Deve ser maior que zero';

  @override
  String get invalidEmail => 'Por favor, insira um e-mail válido';

  @override
  String get invalidAreaCode => 'DDD inválido';

  @override
  String get invalidDate => 'Data inválida';

  @override
  String get invalidIp => 'Formato de IP inválido';

  @override
  String get invalidSession => 'Sessão inválida. Efetue o login novamente';

  @override
  String get postalCodeNotFound => 'Esse CEP não foi encontrado';

  @override
  String get noWorkingUrl =>
      'Nenhuma URL está funcionando. Verifique sua conexão com a internet e caso esteja funcionando, entre em contato com o suporte técnico';

  @override
  String get unsupportedDownload =>
      'Não deveria cair nesse trecho do código. Acione o suporte técnico';

  @override
  String get selectSaveFolder =>
      'Você precisa selecionar uma pasta para salvar o arquivo';

  @override
  String get sharedData => 'Aqui estão os dados gerados pelo CeltaMobile...';

  @override
  String get unexpectedLoginError =>
      'Ocorreu um erro não esperado para efetuar o login';

  @override
  String get success => 'Sucesso';

  @override
  String get invalidResponseStructure => 'Estrutura da resposta inválida';

  @override
  String get httpBadRequest => 'Requisição inválida';

  @override
  String get httpNotFound => 'Recurso não encontrado';

  @override
  String get httpServerError =>
      'Ocorreu um erro no servidor. Tente novamente mais tarde';

  @override
  String get httpUnauthorized =>
      'Não autorizado. Por favor, faça login novamente';

  @override
  String get httpForbidden => 'Acesso negado';

  @override
  String get httpInvalidData => 'Dados inválidos';

  @override
  String maxDecimalPlaces(int count) {
    return 'Máx $count casas decimais';
  }

  @override
  String minimumLength(int count) {
    return 'Precisa ter pelo menos $count caracteres';
  }

  @override
  String invalidDateRange(String start, String end) {
    return 'Período inválido. $start ~ $end';
  }

  @override
  String cannotOpenUrl(String url) {
    return 'Não foi possível abrir $url';
  }

  @override
  String get coreModulesAdjustCost => 'Ajuste de custos';

  @override
  String get coreModulesAdjustPrice => 'Alterar preços';

  @override
  String get coreModulesAdjustStock => 'Ajustar estoque';

  @override
  String get coreModulesBuyQuotation => 'Cotação de compras';

  @override
  String get coreModulesBuyRequest => 'Pedido de compras';

  @override
  String get coreModulesBuyMovement => 'Consulta de compras';

  @override
  String get coreModulesCompetingPrices => 'Preços concorrentes';

  @override
  String get coreModulesCustomerRegister => 'Cadastro de clientes';

  @override
  String get coreModulesExpeditionConference => 'Expedição (conferência)';

  @override
  String get coreModulesInventory => 'Inventário';

  @override
  String get coreModulesPrintLabel => 'Layout de etiquetas';

  @override
  String get coreModulesProcessAuthorization => 'Autorização de processos';

  @override
  String get coreModulesProductsRegister => 'Cadastro de produtos';

  @override
  String get coreModulesReceipt => 'Recebimento';

  @override
  String get coreModulesReports => 'Relatórios';

  @override
  String get coreModulesSaleRequest => 'Pedido de vendas';

  @override
  String get coreModulesSearchProducts => 'Pesquisar produtos';

  @override
  String get coreModulesSynchronizer => 'Sincronismo';

  @override
  String get coreModulesStockReplacement => 'Substituição de estoque';

  @override
  String get coreModulesTransferBetweenStocks => 'Transferência (estoques)';

  @override
  String get coreModulesTransferRequest => 'Pedido de transferência';

  @override
  String get coreBsResourceAdjustStock => 'Ajuste de estoque';

  @override
  String get coreBsResourceAdjustSalePrice => 'Ajuste de preços';

  @override
  String get coreBsResourceChangeSaleRequestPrices =>
      'Alterar preços no pedido de vendas';

  @override
  String get coreBsResourceBuyQuotation => 'Cotação de compras';

  @override
  String get coreBsResourceBuyRequest => 'Pedido de compras';

  @override
  String get coreBsResourceTransferRequest => 'Pedido de transferência';

  @override
  String get coreBsResourceSaleRequest => 'Pedido de vendas';

  @override
  String get coreBsResourceSaleRequestChangeTPrice =>
      'Pedido de vendas (alterar preços)';

  @override
  String get coreBsResourcePriceConference => 'Pesquisa de preços';

  @override
  String get coreBsResourceResearchOfPrice => 'Preços concorrentes';

  @override
  String get coreBsResourceSynchronizer =>
      'Monitor dos serviços de sincronização';

  @override
  String get coreBsResourceSynchronizerDelete =>
      'Monitor dos serviços de sincronização (exclusão)';

  @override
  String get coreBsResourceGoodsReceiving => 'Recebimento de mercadorias';

  @override
  String get coreBsResourceProcessAuthorizationRules =>
      'Regras para autorização de processos';

  @override
  String get corePracticedPriceTypeManual => 'Manual';

  @override
  String get corePracticedPriceTypeRetail => 'Varejo';

  @override
  String get corePracticedPriceTypeWhole => 'Atacado';

  @override
  String get corePracticedPriceTypeOperationalCost => 'Custo operacional';

  @override
  String get corePracticedPriceTypeReplacementCost => 'Custo reposição';

  @override
  String get corePracticedPriceTypeReplacementCostMidle =>
      'Custo reposição médio';

  @override
  String get corePracticedPriceTypeLiquidCost => 'Custo líquido';

  @override
  String get corePracticedPriceTypeLiquidCostMidle => 'Custo líquido médio';

  @override
  String get corePracticedPriceTypeDefinedBySystem => 'Definido pelo sistema';

  @override
  String get corePracticedPriceTypeRealCost => 'Custo real';

  @override
  String get corePracticedPriceTypeRealLiquidCost => 'Custo líquido real';

  @override
  String get corePracticedPriceTypeFiscalCost => 'Custo fiscal';

  @override
  String get corePracticedPriceTypeFiscalLiquidCost => 'Custo líquido fiscal';

  @override
  String get corePracticedPriceTypeEcommerce => 'E-commerce';

  @override
  String get coreOperationTypeExit => 'Saída';

  @override
  String get coreOperationTypeEntrance => 'Entrada';

  @override
  String get coreSearchProductTypePreferenceDynamic => 'Dinâmico';

  @override
  String get coreSearchProductTypePreferencePersonalizedCode =>
      'Cód personalizado';

  @override
  String get coreSearchProductTypePreferenceLegacyCode => 'Cód legado';

  @override
  String get coreSearchProductTypePreferenceEan => 'EAN';

  @override
  String get coreUsageTypeAdjustCost => 'Ajustou custo';

  @override
  String get coreUsageTypeAdjustSalePrice => 'Ajustou preço';

  @override
  String get coreUsageTypeAdjustStock => 'Ajustou estoque';

  @override
  String get coreUsageTypeBuyMovementDetails => 'Consulta compra (detalhes)';

  @override
  String get coreUsageTypeCompleteSearchSaleRequest =>
      'Consulta COMPLETA de pedido de vendas';

  @override
  String get coreUsageTypeCountInventoryProduct =>
      'Contou produto (inventário)';

  @override
  String get coreUsageTypeCountReceiptProduct => 'Contou produto (recebimento)';

  @override
  String get coreUsageTypeDownloadReport => 'Baixou relatório';

  @override
  String get coreUsageTypeFinishedExpedition => 'Finalizou expedição';

  @override
  String get coreUsageTypeGenerateReport => 'Gerou relatório';

  @override
  String get coreUsageTypeInsertBuyRequest => 'Inseriu pedido de compra';

  @override
  String get coreUsageTypeInsertNotFoundReceiptProduct =>
      'Inseriu produto não encontrado (recebimento)';

  @override
  String get coreUsageTypeInsertSaleRequest => 'Inseriu pedido de venda';

  @override
  String get coreUsageTypeInsertTransferRequest =>
      'Inseriu pedido de transferência';

  @override
  String get coreUsageTypeInsertUpdateBuyQuotation =>
      'Inseriu/atualizou cotação de compra';

  @override
  String get coreUsageTypeInsertUpdateCustomer => 'Inseriu/atualizou cliente';

  @override
  String get coreUsageTypeInsertUpdateCompetingPrices =>
      'Atualizou preços concorrentes';

  @override
  String get coreUsageTypeLiberateReceiptDocument => 'Liberou recebimento';

  @override
  String get coreUsageTypeNotDefined => 'Não definido';

  @override
  String get coreUsageTypeUpdateSaleRequest => 'Alterou pedido de vendas';

  @override
  String get coreUsageTypePrintLabelCreateUpdate => 'Criou/atualizou etiqueta';

  @override
  String get coreUsageTypeProcessAuthorizationVote =>
      'Votou (processo de autorização)';

  @override
  String get coreUsageTypeSearchProducts => 'Pesquisou produtos';

  @override
  String get coreUsageTypeSendToPrint => 'Marcou p/ impressão';

  @override
  String get coreUsageTypeShallowBuyMovement =>
      'Consulta compras (superficial)';

  @override
  String get coreUsageTypeShallowSearchProduct =>
      'Consulta produtos (superficial)';

  @override
  String get coreUsageTypeShallowSearchSaleRequest =>
      'Consulta SIMPLES de pedido de vendas';

  @override
  String get coreUsageTypeStockReplacement => 'Substituiu estoque';

  @override
  String get coreUsageTypeSynchronizer => 'Sincronismo (manipulou)';

  @override
  String get coreUsageTypeTransferBetweenStocks => 'Transferiu entre estoques';

  @override
  String get coreCustomerPersonTypeFisica => 'Pessoa física';

  @override
  String get coreCustomerPersonTypeJuridica => 'Pessoa jurídica';

  @override
  String get coreSearchProductCompetingPriceTypeAll => 'Todos';

  @override
  String get coreSearchProductCompetingPriceTypeInformedPrices =>
      'Já informados';

  @override
  String get coreSearchProductCompetingPriceTypeNotInformedPrices =>
      'Não informados';

  @override
  String get coreCustomerSexTypeMale => 'Masculino';

  @override
  String get coreCustomerSexTypeFemale => 'Feminino';

  @override
  String get coreTransferJustificationTypeAdjustStock => 'Ajuste de estoque';

  @override
  String get coreTransferJustificationTypeTransferBetweenStocks =>
      'Transferência entre estoques';

  @override
  String get share => 'Compartilhar';
}
