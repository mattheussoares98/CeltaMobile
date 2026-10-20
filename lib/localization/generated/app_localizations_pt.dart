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

  @override
  String get stockRequired => 'Estoque obrigatório';

  @override
  String get destinationStock => 'Estoque de destino';

  @override
  String get adjustmentCompleted => 'Ajuste efetuado com sucesso';

  @override
  String get replacementCost => 'Custo de reposição';

  @override
  String get changeReplacementCost => 'Alterar custo de reposição';

  @override
  String get confirm => 'Confirmar';

  @override
  String get confirmQuestion => 'Confirmar?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sim';

  @override
  String get newPrice => 'Novo preço';

  @override
  String get startBeforeEnd =>
      'A data de início precisa ser anterior a data de término';

  @override
  String get endAfterStart =>
      'A data de término precisa ser após a data de início';

  @override
  String get startDate => 'Início';

  @override
  String get endDate => 'Término';

  @override
  String get saleType => 'Tipo de venda';

  @override
  String get priceTypeLabel => 'Tipo de preço';

  @override
  String get replicationParameters => 'Parâmetros de replicação';

  @override
  String get loadSchedules => 'Obter agendamentos';

  @override
  String get refreshSchedules => 'Atualizar agendamentos';

  @override
  String get noSchedulesFound => 'Nenhum agendamento foi encontrado';

  @override
  String get createdBy => 'Criado por';

  @override
  String get origin => 'Origem';

  @override
  String get changedOn => 'Alterado em';

  @override
  String get scheduledFor => 'Será executado em';

  @override
  String get changedByClass => 'Alterado via classe';

  @override
  String get changedByPackings => 'Alterado por embalagens';

  @override
  String get changedByGrid => 'Alterado por grade';

  @override
  String get willUpdateClassPrice => 'Vai alterar o preço da classe';

  @override
  String get willUpdateOperationalGroupPrice =>
      'Vai alterar preço do agrupamento operacional das empresas';

  @override
  String get currentPrice => 'Praticado';

  @override
  String get suggestedPrice => 'Sugerido';

  @override
  String get minimumPrice => 'Mínimo';

  @override
  String get belowMinimum => ' MENOR QUE O MÍNIMO';

  @override
  String get priceAdjustmentProducts => 'Produtos (ajuste de preços)';

  @override
  String get priceChangedSuccessfully => 'Preço alterado com sucesso';

  @override
  String get attention => 'Atenção!';

  @override
  String get selectJustificationAndStock =>
      'Você precisa selecionar a justificativa e o estoque!';

  @override
  String get justificationRequired => 'Justificativa obrigatória';

  @override
  String get justifications => 'Justificativas';

  @override
  String get noJustification => 'Sem justificativa';

  @override
  String get noOrigin => 'Sem origem';

  @override
  String get quantity => 'Quantidade';

  @override
  String get noPurchasesFound => 'Nenhuma compra foi encontrada';

  @override
  String get purchaseNotFound => 'A compra não foi encontrada';

  @override
  String get purchaseDetails => 'Detalhes da compra';

  @override
  String get backToTop => 'Voltar ao topo';

  @override
  String get document => 'Documento';

  @override
  String get entranceUser => 'Usuário de entrada';

  @override
  String get createdOn => 'Criado em';

  @override
  String get issuedOn => 'Emitido em';

  @override
  String get receivedOn => 'Entrada em';

  @override
  String get buyers => 'Compradores';

  @override
  String get supplier => 'Fornecedor';

  @override
  String get orders => 'Pedidos';

  @override
  String get netAmount => 'Valor líquido';

  @override
  String get notes => 'Observações';

  @override
  String get details => 'Detalhes';

  @override
  String get grossProductsServicesTotal => 'Total bruto produtos/serviços';

  @override
  String get totalDiscounts => 'Total de descontos';

  @override
  String get offsets => 'Compensações';

  @override
  String get surcharge => 'Acréscimo';

  @override
  String get deliveryFee => 'Taxa de entrega';

  @override
  String get icmsIssBase => 'Base de ICMS e ISS';

  @override
  String get icmsIssAmount => 'Valor de ICMS e ISS';

  @override
  String get icmsStBase => 'Base ICMS substituto';

  @override
  String get invoiceIcmsStAmount => 'Valor ICMS substituto nota fiscal';

  @override
  String get gnreIcmsStAmount => 'Valor ICMS substituto GNRE';

  @override
  String get fcpStAmount => 'Valor FCP substituto';

  @override
  String get freight => 'Frete';

  @override
  String get freightInsurance => 'Seguro frete';

  @override
  String get additionalExpenses => 'Despesas acessórias';

  @override
  String get ipi => 'IPI';

  @override
  String get destinationIcms => 'ICMS destino';

  @override
  String get originIcms => 'ICMS origem';

  @override
  String get povertyReductionFund => 'Fundo de combate à pobreza';

  @override
  String get quantityShort => 'Qtd';

  @override
  String get amount => 'Valor';

  @override
  String get total => 'Total';

  @override
  String get cfop => 'CFOP';

  @override
  String get companyNotFound => 'Empresa não encontrada';

  @override
  String get purchasePeriodTooLong =>
      'A diferença do período não pode ser maior que 90 dias';

  @override
  String get regularPrice => 'Venda';

  @override
  String get offerPrice => 'Oferta';

  @override
  String get replicateClass => 'Classe';

  @override
  String get replicateGrid => 'Grade';

  @override
  String get replicateOperationalGroup => 'Agrupamento operacional';

  @override
  String get replicatePackings => 'Embalagens';

  @override
  String get noCurrentPrice => 'Sem preço praticado';

  @override
  String get noSuggestedPrice => 'Sem preço sugerido';

  @override
  String lastAdjustedQuantity(String direction) {
    return 'Última qtd alterada $direction';
  }

  @override
  String purchaseDetailsWithDocument(String document) {
    return 'Detalhes da compra ($document)';
  }

  @override
  String purchaseCancelledBy(String user) {
    return '$user cancelou essa compra';
  }

  @override
  String noCurrentPriceForType(String priceType, String saleType) {
    return 'Sem preço $priceType $saleType praticado';
  }

  @override
  String noSuggestedPriceForType(String priceType, String saleType) {
    return 'Sem preço $priceType $saleType sugerido';
  }

  @override
  String get quotations => 'Cotações';

  @override
  String get purchaseOrderLookup => 'Consulta de pedidos de compras';

  @override
  String get noPurchaseOrdersFound => 'Nenhum pedido de compra foi encontrado';

  @override
  String get customCode => 'Código personalizado';

  @override
  String get creationDate => 'Data de criação';

  @override
  String get deadline => 'Data limite';

  @override
  String get noDeadline => 'Sem data limite';

  @override
  String get noNotes => 'Sem observações';

  @override
  String get creatingPriceSurvey => 'Inserindo pesquisa';

  @override
  String get editingPriceSurvey => 'Editando pesquisa';

  @override
  String get insert => 'Inserir';

  @override
  String get edit => 'Editar';

  @override
  String get leaveWithoutSaving => 'Sair sem salvar';

  @override
  String get unsavedChangesWarning =>
      'Caso tenha feito alguma alteração, ao sair da página sem salvar, essa alteração será perdida. Deseja sair mesmo assim?';

  @override
  String get inserting => 'Inserindo';

  @override
  String get changing => 'Alterando';

  @override
  String get creatingCompetitor => 'Inserindo concorrente';

  @override
  String get editingCompetitor => 'Alterando concorrente';

  @override
  String get editAddress => 'Inserir/alterar endereço';

  @override
  String get change => 'Alterar';

  @override
  String get pricesChangedSuccessfully => 'Preços alterados com sucesso';

  @override
  String get productAlreadyAdded => 'Esse produto já foi inserido!';

  @override
  String get cannotAddQuotationProducts =>
      'Não foi possível adicionar os produtos. Entre em contato com o suporte';

  @override
  String get save => 'Salvar';

  @override
  String get saveChangesPrompt => 'Deseja salvar as alterações?';

  @override
  String get saveChangesQuestion => 'Salvar alterações?';

  @override
  String get confirmChanges => 'Confirmar alterações';

  @override
  String get filterProducts => 'Filtrar produtos';

  @override
  String get associatedFilter => '(associados)';

  @override
  String get unassociatedFilter => '(não associados)';

  @override
  String get associatedOnly => 'Somente associados';

  @override
  String get loadAllUnassociatedProducts => 'Consultar todos não associados';

  @override
  String get loadAllAssociatedProducts => 'Consultar todos';

  @override
  String get loadAssociatedPricedProducts => 'Consultar todos já informados';

  @override
  String get loadAssociatedUnpricedProducts => 'Consultar todos não informados';

  @override
  String get retailPrice => 'Venda';

  @override
  String get retailOfferPrice => 'Venda (oferta)';

  @override
  String get wholesaleOfferPrice => 'Atacado (oferta)';

  @override
  String get ecommercePrice => 'Ecommerce';

  @override
  String get ecommerceOfferPrice => 'Ecommerce (oferta)';

  @override
  String get associatedWithSurvey => 'Associado à pesquisa';

  @override
  String get notAssociatedWithSurvey => 'Não associado à pesquisa';

  @override
  String get editCompetitor => 'Alterar concorrente';

  @override
  String get unexpectedQuotationError =>
      'Esse erro jamais deveria ocorrer. Entre em contato com o suporte técnico';

  @override
  String get pluOrName => 'PLU | Nome';

  @override
  String get moduleDisabled => 'Módulo desabilitado';

  @override
  String get moduleDisabledContactAdmin =>
      'O módulo está desabilitado para essa empresa. Caso queira habilitar, entre em contato com o setor administrativo';

  @override
  String get cannotUpdateQuotationEnterprises =>
      'Não foi possível atualizar as empresas. Entre em contato com o suporte.';

  @override
  String get enterprises => 'Empresas';

  @override
  String get cnpj => 'CNPJ';

  @override
  String get buyer => 'Comprador';

  @override
  String get selectBuyer => 'Selecione um comprador';

  @override
  String get priceSurveys => 'Pesquisas cadastradas';

  @override
  String get selectRequestTemplate => 'Selecione um modelo de pedido';

  @override
  String get selectSupplier => 'Selecione um fornecedor';

  @override
  String get selectEnterprise => 'Selecione pelo menos uma empresa';

  @override
  String get identification => 'Identificação';

  @override
  String get products => 'Produtos';

  @override
  String get confirmation => 'Confirmação';

  @override
  String get requestTemplate => 'Modelo de pedido';

  @override
  String get changingTemplateRemovesSelection =>
      'Ao alterar o modelo, as empresas e produtos selecionados serão removidos';

  @override
  String get selectTemplate => 'Selecione um modelo';

  @override
  String get select => 'Selecione';

  @override
  String get cost => 'Custo';

  @override
  String get clearOrder => 'Limpar pedido';

  @override
  String get deleteData => 'Apagar dados';

  @override
  String get clearOrderConfirmation =>
      'Tem certeza que deseja remover todos dados inseridos?';

  @override
  String get restrictedProducts => 'Produtos restringidos';

  @override
  String get unrestrictedProducts => 'Produtos não restringidos';

  @override
  String get editPriceSurvey => 'Alterar pesquisa';

  @override
  String get customCodePrefix => 'Cód personalizado: ';

  @override
  String get deliveredOn => 'Entregue em';

  @override
  String get removeEnterpriseQuestion => 'Remover empresa?';

  @override
  String get removeEnterpriseProductsWarning =>
      'Há produtos informados para essa empresa. Ao remover ela, os produtos serão removidos também';

  @override
  String get remove => 'Remover';

  @override
  String get tradeName => 'Nome fantasia';

  @override
  String get searchSuppliersQuestion => 'Consultar fornecedores?';

  @override
  String get supplierSearchRemovesSelection =>
      'Ao consultar os fornecedores, todas empresas e produtos selecionados serão removidos!';

  @override
  String get query => 'Consultar';

  @override
  String get suppliers => 'Fornecedores';

  @override
  String get changeSupplierQuestion => 'Alterar fornecedor?';

  @override
  String get changingSupplierRemovesSelection =>
      'Ao alterar o fornecedor, todas empresas e produtos selecionados serão removidos';

  @override
  String get addProduct => 'Adicione pelo menos um produto';

  @override
  String get saveOrderQuestion => 'Salvar pedido?';

  @override
  String get orderSavedSuccessfully => 'Pedido salvo com sucesso';

  @override
  String get add => 'Adicionar';

  @override
  String get cpfCnpj => 'CPF/CNPJ';

  @override
  String get tradeType => 'Tipo comércio';

  @override
  String get quotationBuyerRequired => 'O comprador deve ser informado';

  @override
  String get quotationEnterpriseRequired =>
      'Ao menos uma empresa deve ser informada';

  @override
  String get quotationProductRequired =>
      'Ao menos um produto deve ser informado';

  @override
  String get priceSurveyCodeRequired =>
      'Para alterar o concorrente é necessário informar o código da pesquisa';

  @override
  String priceSurveySaved(String operation) {
    String _temp0 = intl.Intl.selectLogic(operation, {
      'create': 'Pesquisa inserida com sucesso',
      'other': 'Pesquisa alterada com sucesso',
    });
    return '$_temp0';
  }

  @override
  String competitorSaved(String operation) {
    String _temp0 = intl.Intl.selectLogic(operation, {
      'create': 'Concorrente inserido com sucesso',
      'other': 'Concorrente alterado com sucesso',
    });
    return '$_temp0';
  }

  @override
  String competitorsForSurvey(int survey) {
    return 'Concorrentes (pesquisa $survey)';
  }

  @override
  String offerPriceLabel(String priceType) {
    return '$priceType (oferta)';
  }

  @override
  String surveyCompetitorTitle(int survey, int competitor) {
    return 'Pesquisa $survey - concorrente $competitor';
  }

  @override
  String productsCount(int count) {
    return 'Produtos ($count)';
  }

  @override
  String filteredProductsCount(int count, int total) {
    return 'Produtos ($count de $total)';
  }

  @override
  String enterprisesCount(int count) {
    return 'Empresas ($count)';
  }

  @override
  String lastSavedOrders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Últimos pedidos salvos',
      one: 'Último pedido salvo',
    );
    return '$_temp0';
  }

  @override
  String lastOrders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Últimos pedidos',
      one: 'Último pedido',
    );
    return '$_temp0';
  }

  @override
  String purchaseOrderDetailsWithCode(String code) {
    return 'Detalhes pedido ($code)';
  }

  @override
  String get updateBs => 'Atualize o BS';

  @override
  String get updateBsToUseThisFeature =>
      'A versão do BS precisa ser atualizada para utilizar essa funcionalidade';

  @override
  String get userLacksPermission => 'Usuário sem permissão';

  @override
  String get start => 'Início ';

  @override
  String get end => 'Fim ';

  @override
  String get goToLogin => 'Ir para login';

  @override
  String get goToHome => 'Ir para home';

  @override
  String get cameraPermission => 'Permissão da câmera';

  @override
  String get allowCameraAccessInYourDeviceSettings =>
      'Permita o acesso à câmera nas configurações do dispositivo.';

  @override
  String get openSettings => 'Abrir configurações';

  @override
  String get noProducts => 'Nenhum produto';

  @override
  String get namePluEanScale => 'NOME-PLU-EAN-%-BALANÇA';

  @override
  String get no => 'Não';

  @override
  String get min => ' (mín';

  @override
  String get noReplacementCost => 'Sem custo de reposição';

  @override
  String get noPrice => 'Sem preço';

  @override
  String get eans => 'EANs';

  @override
  String get currentStock => 'Estoque Atual';

  @override
  String get noPermissionToViewStock => 'Sem permissão p/ ver estoque';

  @override
  String get noCurrentStock => 'Sem estoque atual';

  @override
  String get noAvailableQuantityForSale => 'Sem saldo de venda';

  @override
  String get balance => 'saldo';

  @override
  String get offerEnded => 'Oferta encerrada';

  @override
  String get offerEndedSuccessfullySearchForTheProductAgainToRefresh =>
      'Oferta encerrada com sucesso. Consulte o produto novamente para atualizar as informações';

  @override
  String get stocks => 'Estoques';

  @override
  String get latestPurchases => 'Últimas compras';

  @override
  String get date => 'Data';

  @override
  String get packaging => 'Embalagem';

  @override
  String get prices => 'Preços';

  @override
  String get addresses => 'Endereços';

  @override
  String get purchases => 'Compras';

  @override
  String get costs => 'Custos';

  @override
  String get margins => 'Margens';

  @override
  String get appliedPrices => 'Preços praticados';

  @override
  String get refreshPermissionToEndOffers =>
      'Atualizar permissão para encerrar oferta';

  @override
  String get suggestedPrices => 'Preços sugeridos';

  @override
  String get retail => 'Venda ';

  @override
  String get wholesale => 'Atacado ';

  @override
  String get eCommerce => 'Ecommerce ';

  @override
  String get minimumPrices => 'Preços mínimos';

  @override
  String get info => 'Info';

  @override
  String get net => 'Líquido ';

  @override
  String get averageNet => 'Líquido médio ';

  @override
  String get tax => 'Fiscal ';

  @override
  String get netTax => 'Fiscal líquido ';

  @override
  String get operating => 'Operacional ';

  @override
  String get actual => 'Real ';

  @override
  String get actualNet => 'Real líquido ';

  @override
  String get replacement => 'Reposição ';

  @override
  String get averageReplacement => 'Reposição médio ';

  @override
  String get noAddressesRegisteredForThisProduct =>
      'Não há endereços cadastrados para esse produto';

  @override
  String get addressEs => 'Endereço(s)';

  @override
  String get none => 'Não há';

  @override
  String get onOffer => 'Em oferta';

  @override
  String get minimumWholesaleQuantity => 'Qtd mín atacado';

  @override
  String get removeItem => 'Remover item?';

  @override
  String get quantityInCart => 'Qtd no carrinho';

  @override
  String get enteredPrice => 'Preço digitado';

  @override
  String get discount => 'Desconto';

  @override
  String get technologySolutions => 'Tecnologia & Soluções';

  @override
  String get pleaseWait => 'Aguarde';

  @override
  String get timeNotUpdated => 'Horário não atualizado';

  @override
  String get theTimeCannotBeEarlierThanTheMinimumDate =>
      'O horário não pode ser menor que a data mínima';

  @override
  String get ok => 'OK';

  @override
  String get select2 => 'Selecionar';

  @override
  String get tryAgain => 'Tentar novamente';

  @override
  String get from => 'De ';

  @override
  String get to => 'Para ';

  @override
  String get cart => 'Carrinho';

  @override
  String get thisProductHasAZeroPriceAndTheSelectedOrder =>
      'O produto está com o preço zerado e o modelo de pedido selecionado não permite alterar o preço';

  @override
  String get plu => 'PLU';

  @override
  String get price => 'Preço';

  @override
  String get noProductsAddedToTheCart =>
      'Nenhum produto adicionado ao carrinho';

  @override
  String get sourceCompany => 'Empresa de origem';

  @override
  String get destinationCompany => 'Empresa de destino';

  @override
  String get theSelectedOrderTemplateDoesNotAllowPriceChanges =>
      'O modelo de pedido selecionado não permite alterar o preço';

  @override
  String get lastSavedOrder => 'Últ ped salvo';

  @override
  String get clearCart => 'Limpar carrinho';

  @override
  String get clearCart2 => 'Limpar carrinho?';

  @override
  String get clear => 'Limpar';

  @override
  String get orderSearch => 'Busca de pedidos';

  @override
  String get unmarkForPrinting => 'Desmarcar para impressão';

  @override
  String get markForPrinting => 'Marcar para impressão';

  @override
  String get startDate2 => 'Data início';

  @override
  String get message00000000 => '00/00/0000';

  @override
  String get searchFilters => 'Filtros de busca';

  @override
  String get customCode2 => 'Código Personalizado';

  @override
  String get enterTheCode => 'Digite o código...';

  @override
  String get endDate2 => 'Data final';

  @override
  String get printJobSentSuccessfully => 'Impressão enviada com sucesso';

  @override
  String get orderDetails => 'Detalhes do pedido';

  @override
  String get unableToGenerateThePdfTryAgain =>
      'Não foi possível gerar o PDF. Tente novamente';

  @override
  String get disc => 'Desc';

  @override
  String get surch => 'Acrésc';

  @override
  String get print => 'Imprimir';

  @override
  String get noPaymentDetails => 'Sem financeiro';

  @override
  String get paymentDetails => 'Financeiro';

  @override
  String get discounts => 'Descontos';

  @override
  String get surcharges => 'Acréscimos';

  @override
  String get type => 'Tipo';

  @override
  String get emails => 'E-mails';

  @override
  String get phoneNumbers => 'Telefones';

  @override
  String get batchSentSuccessfully => 'Lote enviado com sucesso';

  @override
  String get batch => 'Lote';

  @override
  String get sourceStock => 'Estoque de origem';

  @override
  String get noDestination => 'Sem destino';

  @override
  String get sameStockAsTheSource => 'Estoque igual ao de origem';

  @override
  String get summary => 'Sumário';

  @override
  String get grossTotal => 'Total bruto';

  @override
  String get orderSurcharge => 'Acréscimo no pedido';

  @override
  String get notAllowed => 'Não permitido';

  @override
  String get orderDiscount => 'Desconto no pedido';

  @override
  String get orderDelivery => 'Entrega do pedido';

  @override
  String get totalSurcharges => 'Total dos acréscimos';

  @override
  String get totalDiscounts2 => 'Total dos descontos';

  @override
  String get totalDeliveryFees => 'Total das taxas de entrega';

  @override
  String get netTotal => 'Total líquido';

  @override
  String get salesperson => 'Vendedor';

  @override
  String get removeSalesperson => 'Remover Vendedor';

  @override
  String get selectACustomer => 'Selecione um cliente!';

  @override
  String get attention2 => 'Atenção';

  @override
  String get theOrderWasSavedSuccessfully => 'O pedido foi salvo com sucesso';

  @override
  String get calculatePrices => 'Calcular preços';

  @override
  String get instructions => 'Instruções';

  @override
  String get emptyBatch => 'Lote vazio';

  @override
  String get newQty => 'Nova qtd';

  @override
  String get reason => ' (Justificativa)';

  @override
  String get request => 'Solicitar';

  @override
  String get request2 => 'Solicitar?';

  @override
  String get clearBatch => 'Limpar lote';

  @override
  String get clearBatch2 => 'Limpar lote?';

  @override
  String get searchForAProductToGetStarted =>
      'Pesquise um produto para começar';

  @override
  String get enterTheCustomer => 'Informe o cliente';

  @override
  String get enterAtLeastOneProduct => 'Informe pelo menos um produto';

  @override
  String get quantityChangedSuccessfully => 'Quantidade alterada com sucesso';

  @override
  String get failedToAddPayment => 'Erro ao adicionar pagamento';

  @override
  String get add2 => 'ADICIONAR';

  @override
  String get noPaymentMethodsAreAvailableForThisOrder =>
      'Nenhuma forma de pagamento está disponível para este pedido.';

  @override
  String get paymentMethod => 'Forma de pagamento';

  @override
  String get selectAPaymentMethod => 'Selecione uma forma de pagamento';

  @override
  String get paymentTerms => 'Condição de pagamento';

  @override
  String get noPaymentTermsAvailableOnlyPaymentTermsWithFixedInstallments =>
      'Nenhuma condição de pagamento disponível. Somente condições de pagamento com composição fixas aparecerão';

  @override
  String get toRegisterPaymentTermsWithFixedInstallmentsOpenCeltabsAnd =>
      'Para cadastrar uma condição com composição fixa, acesse o CeltaBS e vá em \"Cadastros > Financeiro > Condições de pagamento';

  @override
  String get noPaymentsAdded => 'Nenhum pagamento adicionado';

  @override
  String get enteredPayments => 'Pagamentos informados';

  @override
  String get newPaymentMethod => 'Nova forma de pagamento';

  @override
  String get missing => 'Faltando';

  @override
  String get excess => 'Sobrando';

  @override
  String get paymentSurcharge => 'Acréscimo financeiro';

  @override
  String get thisOrderTemplateDoesNotAllowPaymentSurcharges =>
      'Esse modelo de pedido não permite acréscimo financeiro.';

  @override
  String get paymentDiscount => 'Desconto financeiro';

  @override
  String get thisOrderTemplateDoesNotAllowPaymentDiscounts =>
      'Esse modelo de pedido não permite desconto financeiro.';

  @override
  String get cardNumber => 'Número do cartão';

  @override
  String get numberOfInstallments => 'Qtd parcelas';

  @override
  String get expiration => 'Validade';

  @override
  String get selectTheCustomerSAgreementToUseThisPaymentMethod =>
      'Você só pode utilizar essa forma de pagamento se selecionar o convênio do cliente!';

  @override
  String get customerAgreement => 'Convênio do cliente';

  @override
  String get addProductsToTheOrder => 'Adicione produtos no pedido!';

  @override
  String get creatingOrder => 'Inserindo pedido';

  @override
  String get unsavedChanges => 'Alterações não salvas';

  @override
  String get thereAreUnsavedChangesDoYouReallyWantToLeave =>
      'Existem alterações que não foram salvas. Deseja realmente sair?';

  @override
  String get productDetails => 'Detalhe do Produto';

  @override
  String get confirm2 => 'CONFIRMAR';

  @override
  String get areYouSureYouWantToVoidThisProductS =>
      'Tem certeza que deseja anular a contagem desse produto?';

  @override
  String get countedQty => 'Qtd contada';

  @override
  String get noCountedQuantity => 'Sem quantidade contada';

  @override
  String get whenEnabledFindingASingleProductAutomaticallyAddsOneUnit =>
      'Quando essa opção está ativa, ao encontrar um único produto na busca, será somado automaticamente 1 quantidade';

  @override
  String get insertIndividually => 'Inserir individualmente';

  @override
  String get thisActionWillRemoveAllAutomaticDiscountsContinue =>
      'Esta ação irá remover todos os descontos automáticos. Deseja continuar?';

  @override
  String get grossPrice => 'Preço Bruto';

  @override
  String get totalDiscounts3 => 'Total Descontos';

  @override
  String get netTotal2 => 'Total Líquido';

  @override
  String get searchByCustomCode => 'Pesquisar pelo código personalizado';

  @override
  String get frozenProcesses => 'Processos congelados';

  @override
  String get stockType => 'Tipo de estoque';

  @override
  String get personResponsible => 'Responsável';

  @override
  String get frozenOn => 'Congelado em';

  @override
  String get customer => 'Cliente';

  @override
  String get items => 'Itens';

  @override
  String get payment => 'Pagamento';

  @override
  String get summary2 => 'Resumo';

  @override
  String get agreements => 'Convênios';

  @override
  String get customerBlocked => 'Cliente Bloqueado';

  @override
  String get understood => 'Entendido';

  @override
  String get customerChange => 'Alteração do cliente';

  @override
  String get continue2 => 'Deseja prosseguir?';

  @override
  String get todaySOrders => 'Pedidos de hoje';

  @override
  String get noOrdersFound => 'Nenhum pedido encontrado';

  @override
  String get searchAgain => 'Pesquisar novamente';

  @override
  String get counts => 'Contagens';

  @override
  String get noCountsFoundForThisInventoryProcessCreateAtLeast =>
      'Não foram encontradas contagens para esse processe de inventário. Crie pelo menos uma contagem';

  @override
  String get notes2 => 'Obs';

  @override
  String get run => 'Executar';

  @override
  String get selectTheCompany => 'Selecione a empresa';

  @override
  String get orderNo => 'Núm pedido';

  @override
  String get totalDelivery => 'Total de entrega';

  @override
  String get totalSurcharges2 => 'Total acréscimos';

  @override
  String get totalDiscounts4 => 'Total descontos';

  @override
  String get unableToLoadTheOrderTryAgain =>
      'Não foi possível carregar o pedido. Tente novamente';

  @override
  String get pdf => 'PDF';

  @override
  String get theQuantityCannotBeNegative =>
      'A quantidade não pode ficar negativa';

  @override
  String get printerIp => 'IP da impressora';

  @override
  String get yourUserDoesNotHavePermissionToPerformThisAction =>
      'Seu usuário não possui permissão para realizar esse procedimento';

  @override
  String get rereadAll => 'Reler todos';

  @override
  String get rereadSelected => 'Reler selecionados';

  @override
  String get deleteAll => 'Excluir todos';

  @override
  String get deleteSelected => 'Excluir selecionados';

  @override
  String get ignoreAll => 'Ignorar todos';

  @override
  String get ignoreSelected => 'Ignorar selecionados';

  @override
  String get resendAll => 'Reenviar todos';

  @override
  String get resendSelected => 'Reenviar selecionados';

  @override
  String get unmarkAll => 'Desmarcar todos';

  @override
  String get unmarkSelected => 'Desmarcar selecionados';

  @override
  String get rereadAll2 => 'Reler todas';

  @override
  String get rereadSelected2 => 'Reler selecionadas';

  @override
  String get displayingThisTypeOfErrorHasNotBeenImplementedYet =>
      'A visualização desse tipo de erro ainda não foi implementada';

  @override
  String get pleaseSelectACustomerBeforeSaving =>
      'Por favor, selecione um cliente antes de salvar.';

  @override
  String get addAtLeastOneProductToTheOrder =>
      'Adicione pelo menos um produto ao pedido.';

  @override
  String get noOrderTemplateSelectedThisIsAProgrammingErrorPlease =>
      'O modelo de pedido não está selecionado. Esse erro jamais deveria acontecer, é um erro de programação. Entre em contato com o suporte técnico';

  @override
  String get thisOrderTemplateRequiresPaymentDetailsPleaseFillInThe =>
      'O modelo de pedido obriga a que o financeiro seja informado. Por favor, preencha as formas de pagamento corretamente.';

  @override
  String get thisOrderTemplateDoesNotAllowPriceChangesProcessThe =>
      'O modelo de pedido não permite alterar os preços. Por isso, processe o carrinho.';

  @override
  String get yourUserDoesNotHavePermissionToChangeOrderPrices =>
      'O usuário não possui permissão para alterar os preços no pedido. Por isso, processe o carrinho';

  @override
  String get thisOrderHasNotBeenProcessedToCalculatePricesBased =>
      'O pedido ainda não foi processado para calcular os preços de acordo com promoções, negociações de vendas, oferta, atacado, preço praticado pelo modelo de pedido, etc!\n\n Deseja salvar mesmo assim?';

  @override
  String get website => 'Site';

  @override
  String get description => 'Descrição';

  @override
  String get websiteId => 'ID Site';

  @override
  String get sentOn => 'Data envio';

  @override
  String get selectError => 'Selecionar erro';

  @override
  String get selectOrder => 'Selecionar pedido';

  @override
  String get lastRead => 'Última leitura';

  @override
  String get orderCreation => 'Criação do pedido';

  @override
  String get invoice => 'Fatura';

  @override
  String get order => 'Pedido';

  @override
  String get productsNotFound => 'Produtos não encontrados';

  @override
  String get websiteCode => 'Cód site';

  @override
  String get product => 'Produto';

  @override
  String get link => 'Associar';

  @override
  String get searchForAndSelectTheProductToLink =>
      'Pesquise e selecione o produto a ser associado';

  @override
  String get viewProduct => 'Consultar produto';

  @override
  String get noProductsFound => 'Nenhum produto foi encontrado';

  @override
  String get linkProduct => 'Deseja associar?';

  @override
  String get viewOrder => 'Visualizar pedido';

  @override
  String get register => 'Caixa';

  @override
  String get errorDate => 'Data erro';

  @override
  String get cashWithdrawalDate => 'Data sangria';

  @override
  String get selectProduct => 'Selecionar produto';

  @override
  String get productIdOnWebsite => 'ID do Produto no Site';

  @override
  String get errorDescription => 'Descrição do erro';

  @override
  String get moreErrorInformation => 'Mais informações do erro';

  @override
  String get productUpload => 'Carga do produto';

  @override
  String get priceUpload => 'Carga de preços';

  @override
  String get stockUpload => 'Carga de estoques';

  @override
  String get notSentToWebsite => 'Não enviado ao site';

  @override
  String get sentToWebsite => 'Enviado ao site';

  @override
  String get resend => 'Reenviar';

  @override
  String get ignored => 'Ignorados';

  @override
  String get issueDate => 'Emissão';

  @override
  String get invoice2 => 'NF';

  @override
  String get series => 'Série';

  @override
  String get orderTemplateNotFound => 'Modelo de pedido não encontrado';

  @override
  String get thisProductHasNoPrice => 'Esse produto não possui preço';

  @override
  String get theProductSNetAmountCannotBeNegative =>
      'O valor líquido do produto não pode ser negativo.';

  @override
  String get theProductSNetAmountMustBeGreaterThanZero =>
      'O valor líquido do produto deve ser maior que zero';

  @override
  String get theProductSNetAmountMustBeGreaterThanZero2 =>
      'O valor líquido do produto deve ser maior que zero.';

  @override
  String get unexpectedError => 'Erro não esperado';

  @override
  String get amountExceedsTheAvailableBalance => 'Valor excede o disponível';

  @override
  String get selectAnAgreement => 'Selecione um convênio';

  @override
  String get theOrderTemplateDoesNotAllowPaymentSurcharges =>
      'O modelo de pedido não permite acréscimo financeiro';

  @override
  String get theAmountMustBeGreaterThanZero =>
      'O valor deve ser maior que zero';

  @override
  String get selectTheSurchargeType => 'Selecione o tipo de acréscimo';

  @override
  String get theOrderTemplateDoesNotAllowPaymentDiscounts =>
      'O modelo de pedido não permite desconto financeiro';

  @override
  String get selectTheDiscountType => 'Selecione o tipo de desconto';

  @override
  String get manualDiscount => 'Desconto manual';

  @override
  String get invalidState => 'Estado inválido';

  @override
  String get addProductsToTheOrder2 => 'Insira produtos no pedido';

  @override
  String get enterTheOrderTemplate => 'Informe o modelo de pedido';

  @override
  String get selectTheWebsite => 'Selecione o site';

  @override
  String get orderId => 'ID do pedido';

  @override
  String get addForRereading => 'Inserir para releitura';

  @override
  String get customerName => 'Nome cliente';

  @override
  String get registrationDate => 'Data cadastro';

  @override
  String get customerCode => 'Cód cliente';

  @override
  String get selectReceipt => 'Selecionar cupom';

  @override
  String get saleDate => 'Dia da venda';

  @override
  String get receipt => 'Cupom';

  @override
  String get pos => 'PDV';

  @override
  String get creation => 'Criação';

  @override
  String get openingClosing => 'Abertura/Fechamento';

  @override
  String get noCustomersFound => 'Nenhum cliente foi encontrado';

  @override
  String get theEnteredDocumentNumberWasNotFound =>
      'o número de documento informado não foi encontrado';

  @override
  String get noErrorsFound => 'Nenhum erro foi encontrado';

  @override
  String get reload2 => 'Recarregar';

  @override
  String get message404PageNotFound => '404 - Página não encontrada!';

  @override
  String get anErrorOccurred => 'Ocorreu um erro';

  @override
  String get userDoesNotHavePermissionToAccessThisModule =>
      'Usuário sem permissão para acessar este módulo';

  @override
  String get rereadingThisDetailTypeHasNotBeenImplemented =>
      'Tipo de detalhe para ler novamente não implementado';

  @override
  String get deletingThisDetailTypeHasNotBeenImplemented =>
      'Tipo de detalhe para deletar não implementado';

  @override
  String get productDetails2 => 'Detalhes do produto';

  @override
  String get searchProperty => 'Pesquisar propriedade...';

  @override
  String get notImplementedYet => 'Ainda não implementado';

  @override
  String get theProductWasNotFound => 'O produto não foi encontrado';

  @override
  String get notProvided => 'Nao informada';

  @override
  String get notProvided2 => 'Nao informado';

  @override
  String get notProvided3 => 'Não informada';

  @override
  String get notProvided4 => 'Não informado';

  @override
  String get paymentMethods => 'Formas de Pagamento';

  @override
  String get itemTotal => 'Total do item';

  @override
  String get subtotalR => 'Subtotal R\$';

  @override
  String get totalDiscountsR => 'Total descontos R\$';

  @override
  String get totalSurchargesR => 'Total acrescimos R\$';

  @override
  String get totalShippingR => 'Total frete R\$';

  @override
  String get totalR => 'TOTAL R\$ ';

  @override
  String get notes3 => 'Observacoes ';

  @override
  String get instructions2 => 'Instrucoes ';

  @override
  String get salesOrderNotFoundSearchForOrdersAgainToCheck =>
      'Pedido de venda não encontrado. Consulte os pedidos novamente para confirmar se ele está disponível';

  @override
  String get developedByCeltaware => 'Desenvolvido por Celtaware';

  @override
  String get orderTemplate => 'Modelo de Pedido:';

  @override
  String get issueDate2 => 'Data de Emissão:';

  @override
  String get paymentDiscount2 => 'Desconto Financeiro:';

  @override
  String get paymentSurcharge2 => 'Acréscimo Financeiro:';

  @override
  String get discount2 => 'Desconto:';

  @override
  String get surcharge2 => 'Acréscimo:';

  @override
  String get shipping => 'Frete:';

  @override
  String get netTotal3 => 'Total Líquido:';

  @override
  String get instructions3 => 'Instruções:';

  @override
  String get notes4 => 'Observações:';

  @override
  String get surch2 => 'Acrés';

  @override
  String get installments => 'Parcelas';

  @override
  String get immediatePayment => 'À vista';

  @override
  String get suspended => 'Suspenso';

  @override
  String get signOut => 'Sair';

  @override
  String get areYouSureYouWantToSignOut => 'Tem certeza que deseja sair?';

  @override
  String get create => 'Criar';

  @override
  String get createSalesOrders => 'Crie pedidos de venda';

  @override
  String get searchSalesOrders => 'Pesquise pedidos de vendas';

  @override
  String get createPurchaseOrders => 'Crie pedido de compras';

  @override
  String get searchPurchaseOrders => 'Pesquise pedidos de compras';

  @override
  String get authorized => 'Autorizado';

  @override
  String get unauthorized => 'Não autorizado';

  @override
  String get category => 'Categoria';

  @override
  String get subcategory => 'Sub categoria';

  @override
  String get report => 'Relatório';

  @override
  String get reportHasNoDataToDisplay => 'Relatório SEM DADOS para exibir';

  @override
  String get theReportIsBeingGeneratedAgainSomeReportsTakeLonger =>
      'O relatório está sendo gerado novamente.\n\nAlguns relatórios demoram para serem gerados. Por isso, aguarde alguns instantes e consulte os relatórios novamente para verificar se a data da última geração foi alterada';

  @override
  String get lastGenerated => 'Última geração';

  @override
  String get generate => 'Gerar';

  @override
  String get sendByEmail => 'Enviar por e-mail?';

  @override
  String get startedBy => 'Iniciado por';

  @override
  String get thisProcessHasAlreadyBeenReviewed =>
      'Esse processo já foi julgado';

  @override
  String get vote => 'Votar';

  @override
  String get view => 'Visualizar';

  @override
  String get viewPath => 'Visualizar caminho';

  @override
  String get filePath => 'Caminho do arquivo';

  @override
  String get spreadsheetDownloaded => 'Planilha baixada';

  @override
  String get downloadSpreadsheet => 'Baixar planilha';

  @override
  String get downloadPdf => 'Baixar PDF';

  @override
  String get pdfDownloaded => 'PDF baixado';

  @override
  String get discountAnalysis => 'Análise de descontos';

  @override
  String get profitabilityAnalysis => 'Análise de lucratividade';

  @override
  String get noDiscountsFound => 'Nenhum desconto encontrado';

  @override
  String get noProfitabilityDataFound => 'Nenhuma lucratividade encontrada';

  @override
  String get replacement2 => 'Reposição';

  @override
  String get netCost => 'Cust líq';

  @override
  String get operatingExp => 'Desp op';

  @override
  String get tax2 => 'Imposto';

  @override
  String get revenue => 'Faturamento';

  @override
  String get profit => 'Lucro';

  @override
  String get margin => 'Margem';

  @override
  String get min2 => 'Mín';

  @override
  String get unitDiff => 'Dif unit';

  @override
  String get totalDiff => 'Dif total';

  @override
  String get gross => 'Bruto';

  @override
  String get net2 => 'Líquido';

  @override
  String get max => 'Máx';

  @override
  String get difference => 'Diferença';

  @override
  String get awaitingAuthorization => 'Aguardando autorização';

  @override
  String get unauthorized2 => 'Não autorizados';

  @override
  String get stockToReplace => 'Estoque a ser substituído';

  @override
  String get selectTheStock => 'Você precisa selecionar o estoque!';

  @override
  String get attention3 => 'Atenção!!!';

  @override
  String get confirmingWillUpdateTheProductSStockToTheQuantity =>
      'Ao confirmar, o estoque do produto será atualizado para a quantidade que você informou!\n\nDeseja continuar?';

  @override
  String get lastAcceptedQty => 'Última qtd ASSUMIDA';

  @override
  String get noProcessesFoundWithStatus =>
      'Não foram encontrados processos com o status ';

  @override
  String get processStartedBy => 'Processo iniciado por';

  @override
  String get authorizers => 'Autorizadores';

  @override
  String get reviews => 'Julgamentos';

  @override
  String get linkToThisProduct => 'Deseja associar a esse produto?';

  @override
  String get countedQty2 => 'Qtd contagem';

  @override
  String get xmlDifferences => 'Diferenças de XML';

  @override
  String get notReviewed => 'Não julgados';

  @override
  String get reviewed => 'Julgados';

  @override
  String get notRegistered => 'Sem cadastro';

  @override
  String get noReviewedProducts => 'Não há produtos julgados';

  @override
  String get allProductsHaveAlreadyBeenReviewed =>
      'Todos produtos já foram julgados';

  @override
  String get invoiceQty => 'Qtd NF';

  @override
  String get orderQty => 'Qtd ped';

  @override
  String get otherOrderQty => 'Qtd outr ped';

  @override
  String get qtyDiff => 'Dif qtd';

  @override
  String get invoiceNetAmount => 'Vl líq NF';

  @override
  String get orderNetAmount => 'Vl líq ped';

  @override
  String get netAmountDiff => 'Dif vl líq';

  @override
  String get totalNetAmountDiff => 'Tot dif vl líq';

  @override
  String get returnAllQuantitiesOfTheSelectedProducts =>
      'Deseja devolver todas as quantidades dos produtos selecionados?';

  @override
  String get returnOnlyTheExcessQuantityOfTheSelectedProducts =>
      'Deseja devolver somente a quantidade excedente dos produtos selecionados?';

  @override
  String get acceptTheDiscrepanciesForTheSelectedProducts =>
      'Deseja aceitar as divergências dos produtos selecionados?';

  @override
  String get voidTheReviewsOfTheSelectedProducts =>
      'Deseja anular os julgamentos dos produtos selecionados?';

  @override
  String get voidReviews => 'Anular julgamentos';

  @override
  String get accept => 'Aceitar';

  @override
  String get returnExcess => 'Devolver excesso';

  @override
  String get unableToFindTheDocument =>
      'Não foi possível encontrar o documento';

  @override
  String get sourceCompany2 => 'Empresa origem';

  @override
  String get documentType => 'Tipo de documento';

  @override
  String get nfeKey => 'Chave NFe';

  @override
  String get nfeSeries => 'Série NFe';

  @override
  String get verificationCompleted => 'Conferência concluída!';

  @override
  String get leavingWillDiscardTheCountedQuantitiesLeaveAnyway =>
      'Ao sair, as quantidades contadas serão perdidas. Deseja sair mesmo assim?';

  @override
  String get noProductsVerifiedYet => 'Nenhum produto conferido até o momento';

  @override
  String get selectTheProductToConfirm =>
      'Selecione o produto que deseja confirmar';

  @override
  String get pending => 'Pendentes';

  @override
  String get verified => 'Conferidos';

  @override
  String get documents => 'Documentos';

  @override
  String get settings => 'Configurações';

  @override
  String get reloadSettings => 'Recarregar configurações';

  @override
  String get noDocumentsAreUndergoingProductVerification =>
      'Nenhum documento está no processo de conferência de produtos';

  @override
  String get step => 'Etapa';

  @override
  String get productSearchType => 'Tipo de pesquisa de produtos';

  @override
  String get autoScan => 'Auto scan';

  @override
  String get goodsReceipts => 'Recebimentos';

  @override
  String get numberIssuerStatusNote => 'Número|Emitente|Status|Observação';

  @override
  String get filter => 'Filtrar';

  @override
  String get thisProductIsNotPendingVerification =>
      'Esse produto não está pendente para conferência';

  @override
  String get addNote => 'Inserir obs';

  @override
  String get editNote => 'Alterar obs';

  @override
  String get issuer => 'Emitente';

  @override
  String get group => 'Grupo';

  @override
  String get newNote => 'Nova observação';

  @override
  String get pendingNote => 'Observação pendente';

  @override
  String get alreadyReleased => 'Já liberado';

  @override
  String get release => 'Liberar';

  @override
  String get thisDocumentIsUndergoingAuthorizationAndCannotBeReleased =>
      'Esse documento está em processo de autorização e por isso não pode ser liberado';

  @override
  String get release2 => 'Liberar?';

  @override
  String get areYouSureYouWantToReleaseThisDocument =>
      'Tem certeza que deseja liberar esse documento?';

  @override
  String get verifyProducts => 'Conferir produtos';

  @override
  String get defaultNote => 'Observação padrão';

  @override
  String get confirmNote => 'Confirmar obs';

  @override
  String get newExpirationDate => 'Nova validade';

  @override
  String get none2 => 'Nenhuma';

  @override
  String get subtract => 'Subtrair';

  @override
  String get add3 => 'Somar';

  @override
  String get areYouSureYouWantToVoidTheCount =>
      'Tem certeza que deseja anular a contagem?';

  @override
  String get updateRequired => 'Atualização necesssária!';

  @override
  String get askBsSupportToUpdateTheSystemToUseThis =>
      'Para utilizar essa funcionalidade, peça para o suporte do BS atualizar o sistema';

  @override
  String get weighedProducts => 'Pesáveis';

  @override
  String get noEan => 'Sem EAN';

  @override
  String get alreadyCounted => 'Já contados';

  @override
  String get noExpirationDate => 'Sem validade';

  @override
  String get countedQuantity => 'Quantidade contada';

  @override
  String get theNewQuantityCannotBeLessThanZero =>
      'A nova quantidade não pode ser menor que zero';

  @override
  String get personalDetails => 'Dados pessoais';

  @override
  String get saveDetails => 'Salvar dados?';

  @override
  String get thereAreStillUnregisteredProductsTheyNeedToBeLinked =>
      'Ainda existem produtos sem cadastros. Eles precisam ser vinculados';

  @override
  String get reviewAllProductsBeforeVoting =>
      'Julgue todos os produtos antes de votar';

  @override
  String get cpfCnpj2 => 'CPF/CNPJ ';

  @override
  String get name2 => 'Nome ';

  @override
  String get shortName => 'Nome reduzido ';

  @override
  String get birthDate => 'Nascimento ';

  @override
  String get password2 => 'Senha ';

  @override
  String get sex => 'Sexo ';

  @override
  String get unableToLoadTheSalesOrderData =>
      'Não foi possível carregar os dados do pedido de vendas';

  @override
  String get processNotFound => 'Processo não encontrado';

  @override
  String get filterCompany => 'Filtrar empresa';

  @override
  String get filterUsageType => 'Filtrar tipo de uso';

  @override
  String get thisPhoneNumberHasAlreadyBeenAdded =>
      'Esse telefone já foi adicionado';

  @override
  String get addPhoneNumber => 'Adicionar telefone';

  @override
  String get update => 'Atualizar';

  @override
  String get monthYear => 'Mês/ano';

  @override
  String get noUsageFound => 'Nenhum uso encontrado';

  @override
  String get noResultsFound => 'Nenhum resultado encontrado';

  @override
  String get requestsByType => 'Requisições por tipo';

  @override
  String get requestsByUser => 'Requisições por usuário';

  @override
  String get manageModules => 'Gerenciar módulos';

  @override
  String get usage => 'Uso';

  @override
  String get phone => 'Telefone';

  @override
  String get enteredPhoneNumbers => 'Telefones informados';

  @override
  String get removePhoneNumber => 'Remover telefone?';

  @override
  String get noCompaniesFound => 'Nenhuma empresa encontrada.';

  @override
  String get noPermission => 'Sem permissão';

  @override
  String get onlyAdministratorsCanMakeThisChange =>
      'Somente administradores podem fazer essa alteração';

  @override
  String get sex2 => 'Sexo';

  @override
  String get shortName2 => 'Nome reduzido';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não conferem';

  @override
  String get stateTaxRegistration => 'Inscrição estadual';

  @override
  String get birthDate2 => 'Nascimento';

  @override
  String get companyRegisteredSuccessfully => 'Empresa cadastrada com sucesso';

  @override
  String get createCompany => 'Criar empresa';

  @override
  String get bsUsername => 'Nome do usuário no BS';

  @override
  String get remoteHttp => 'HTTP remota';

  @override
  String get remoteHttps => 'HTTPS remota';

  @override
  String get enteredEmails => 'E-mails informados';

  @override
  String get removeEmail => 'Remover e-mail?';

  @override
  String get localHttp => 'HTTP local';

  @override
  String get thisEmailHasAlreadyBeenAdded => 'Esse e-mail já foi adicionado';

  @override
  String get email => 'E-mail';

  @override
  String get enterEmail => 'Inserir e-mail';

  @override
  String get localHttps => 'HTTPS local';

  @override
  String get companyName => 'Nome da empresa';

  @override
  String get customerSavedSuccessfully =>
      'Cliente cadastrado/atualizado com sucesso';

  @override
  String get details2 => 'Dados';

  @override
  String get unlinkedAgreements => 'Convênios sem vínculo';

  @override
  String get cnpj2 => 'CNPJ ';

  @override
  String get address2 => 'Endereço ';

  @override
  String get limitR => 'Limite R\$';

  @override
  String get link2 => 'Vincular';

  @override
  String get linkedAgreements => 'Convênios vinculados';

  @override
  String get code2 => 'Código ';

  @override
  String get limit => 'Limite ';

  @override
  String get removeAgreement => 'Remover convênio';

  @override
  String get areYouSureYouWantToRemoveThisAgreement =>
      'Tem certeza que deseja remover esse convênio?';

  @override
  String get remoteHttp2 => 'HTTP remoto';

  @override
  String get remoteHttps2 => 'HTTPS remoto';

  @override
  String get enabled => 'Habilitado';

  @override
  String get inherit => 'Herdar';

  @override
  String get disabled => 'Desabilitado';

  @override
  String get permissionsChangedSuccessfully =>
      'Permissões alteradas com sucesso';

  @override
  String get globalPermissions => 'Permissões globais';

  @override
  String get specificPermissions => 'Permissões específicas';

  @override
  String get companyNotFound2 => 'Empresa não encontrada.';

  @override
  String get requestTimedOutPleaseTryAgain =>
      'Tempo limite atingido. Por favor, tente novamente.';

  @override
  String get connectionErrorCheckYourInternetConnection =>
      'Erro de conexão. Verifique a sua internet.';

  @override
  String get invalidLoginCredentialsCheckYourEmailAndPassword =>
      'Credenciais de login inválidas. Por favor, verifique seu e-mail e senha.';

  @override
  String get thePasswordMustContainAtLeast6Characters =>
      'A senha deve ter pelo menos 6 caracteres.';

  @override
  String get thisEmailIsAlreadyRegistered => 'Este e-mail já está cadastrado.';

  @override
  String get invalidEmailFormat => 'Formato de e-mail inválido.';

  @override
  String get thisActionIsTemporarilyBlockedTryAgainLater =>
      'Essa ação está bloqueada temporariamente. Tente novamente daqui a pouco.';

  @override
  String get methodNotFoundTellTechnicalSupportThatTheApiIs =>
      'O método não foi encontrado. Informe o suporte técnico que a API não está funcionando ou deve ser atualizada';

  @override
  String get login => 'Login';

  @override
  String get postalCode2 => 'CEP ';

  @override
  String get deleteAddress => 'Excluir endereço?';

  @override
  String get addressComplement => 'Complemento ';

  @override
  String get reference2 => 'Referência ';

  @override
  String get thisAddressHasAlreadyBeenAdded => 'Esse endereço já foi inserido';

  @override
  String get labelLayouts => 'Leiautes de etiquetas';

  @override
  String get reportedIssues => 'Problemas reportados';

  @override
  String get noLabelLayoutsFound => 'Nenhum leiaute de etiqueta encontrado';

  @override
  String get printer => 'Impressora';

  @override
  String get noReportedIssues => 'Nenhum problema reportado';

  @override
  String get unableToLoadTheImage => 'Não foi possível carregar a imagem';

  @override
  String get labelPhoto => 'Foto da etiqueta';

  @override
  String get canvasImage => 'Imagem do canvas';

  @override
  String get issueReport => 'Relato';

  @override
  String get layout => 'Leiaute';

  @override
  String get environment => 'Ambiente';

  @override
  String get failedToCaptureTheCanvas => 'Falha ao capturar o canvas';

  @override
  String get copyDiagnostics => 'Copiar diagnóstico';

  @override
  String get close => 'Fechar';

  @override
  String get reportAPrintingIssue => 'Relatar problema de impressão';

  @override
  String get checkTheSavedLayoutBeforeTakingAPhoto =>
      'Confira o leiaute salvo antes de fotografar.';

  @override
  String get sendingReport => 'Enviando relatório...';

  @override
  String get reportCanceled => 'Relatório cancelado.';

  @override
  String get issueDetails => 'Detalhes do problema';

  @override
  String get describeTheExpectedResultAndTheIssueEncountered =>
      'Explique o resultado esperado e o problema encontrado';

  @override
  String get iAuthorizeSendingBothImagesTheSavedLayoutMyName =>
      'Autorizo o envio das duas imagens, leiaute salvo, meu nome, empresa e dados seguros do app/dispositivo ao suporte técnico';

  @override
  String get sendReport => 'Enviar relatório';

  @override
  String get retakeCaptures => 'Refazer capturas';

  @override
  String get reportSent => 'Relatório enviado';

  @override
  String get unableToCompleteTheReport =>
      'Não foi possível concluir o relatório.';

  @override
  String get theEntireLabelIsVisible => 'A etiqueta inteira está visível';

  @override
  String get thereIsARulerAboveOrBelowTheLabel =>
      'Há uma régua acima ou abaixo da etiqueta';

  @override
  String get thePhotoIsInFocusAndHasNoGlare =>
      'A foto está focada e sem reflexo';

  @override
  String get takeAnotherPhoto => 'Tirar outra foto';

  @override
  String get useThisPhoto => 'Usar esta foto';

  @override
  String get takePhoto => 'Fotografar';

  @override
  String get addFieldToLayout => 'Adicionar campo ao leiaute';

  @override
  String get layoutSavedSuccessfully => 'Leiaute salvo com sucesso';

  @override
  String get allChangesWillBeLostCloseThisScreen =>
      'Todas alterações realizadas serão perdidas. Deseja realmente fechar a tela?';

  @override
  String get discardChanges => 'Descartar alterações';

  @override
  String get allChangesWillBeLostRefreshTheData =>
      'Todas as alterações realizadas serão perdidas. Deseja realmente atualizar os dados?';

  @override
  String get layoutDetails => 'Detalhes do leiaute';

  @override
  String get selectThePrinter => 'Selecione a impressora';

  @override
  String get addField => 'Adicionar campo';

  @override
  String get printerFormAndLabel => 'Impressora, formulário e etiqueta';

  @override
  String get noFieldsConfigured => 'Nenhum campo configurado';

  @override
  String get hideFromPreview => 'Ocultar do preview';

  @override
  String get showInPreview => 'Exibir no preview';

  @override
  String get reportIssue => 'Relatar problema';

  @override
  String get saveTheLayout => 'Salve o leiaute';

  @override
  String get saveOrDiscardChangesBeforeReportingAnIssue =>
      'Salve ou descarte as alterações antes de relatar um problema.';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get saveTheseChanges => 'Deseja realmente salvar as alterações?';

  @override
  String get logo => 'Logotipo';

  @override
  String get field => 'Campo';

  @override
  String get preview => 'Pré-visualização ';

  @override
  String get approximate => '(APROXIMADA)';

  @override
  String get addFieldsToDetermineThePreviewHeight =>
      'Adicione campos para determinar a altura da pré-visualização';

  @override
  String get enterAValidWidthAndHeightToPreviewTheLabel =>
      'Informe uma largura e altura válidas para visualizar a etiqueta';

  @override
  String get printerParameters => 'Parâmetros da impressora';

  @override
  String get temperature => 'Temperatura';

  @override
  String get speed => 'Velocidade';

  @override
  String get packetInterval => 'Intervalo do pacote';

  @override
  String get dots => 'pontos';

  @override
  String get width => 'Largura';

  @override
  String get height => 'Altura';

  @override
  String get rightMargin => 'Mg direita';

  @override
  String get bottomMargin => 'Mg inferior';

  @override
  String get labelDirection => 'Direção da etiqueta';

  @override
  String get considerProductPackaging => 'Considerar embalagem do produto';

  @override
  String get enterPrintQuantityPerProduct =>
      'Informar quantidade de impressão por produto';

  @override
  String get printOneLabelForEachUnitSold =>
      'Imprimir uma etiqueta para cada unidade vendida';

  @override
  String get onlyProductsSentToInventoryCountingThatAllowACounted =>
      'Somente produtos enviados para balanço e que permitem quantidade no balanço';

  @override
  String get top => 'Superior';

  @override
  String get left => 'Esquerda';

  @override
  String get bottom => 'Inferior';

  @override
  String get right => 'Direita';

  @override
  String get layoutName => 'Nome do leiaute';

  @override
  String get fieldsIncompatibleWithTheNewTypeWillBeRemoved =>
      'Os campos incompatíveis com o novo tipo serão removidos.';

  @override
  String get addressType => 'Tipo de endereço';

  @override
  String get main => 'Principal';

  @override
  String get billing => 'Cobrança';

  @override
  String get delivery => 'Entrega';

  @override
  String get notApplicable => 'Não se aplica';

  @override
  String get formType => 'Tipo de formulário';

  @override
  String get height2 => 'Altura *';

  @override
  String get topMargin => 'Mg superior';

  @override
  String get leftMargin => 'Mg esquerda';

  @override
  String get columns => 'Colunas';

  @override
  String get applyFormSizeSettings =>
      'Aplicar configuração do tamanho do formulário';

  @override
  String get content => 'Conteúdo';

  @override
  String get prefix => 'Prefixo';

  @override
  String get xAxis => 'Eixo X';

  @override
  String get yAxis => 'Eixo Y';

  @override
  String get size => 'Tamanho';

  @override
  String get rotation => 'Rotação';

  @override
  String get imageName => 'Nome da imagem';

  @override
  String get barcodeType => 'Tipo do código de barras';

  @override
  String get dataField => 'Campo representante do dado';

  @override
  String get printTextBelowTheBarcode =>
      'Imprimir o texto abaixo do código de barras';

  @override
  String get alignment => 'Alinhamento';

  @override
  String get format => 'Formato';

  @override
  String get decimalPlaces => 'Casas decimais';

  @override
  String get fontType => 'Tipo da fonte';

  @override
  String get fontSize => 'Tamanho da fonte';

  @override
  String get startingPosition => 'Posição inicial';

  @override
  String get maximumCharacters => 'Máximo de caracteres';

  @override
  String get printBoldText => 'Imprimir texto em negrito';

  @override
  String get printReverseText => 'Imprimir texto reverso';

  @override
  String get continueAction => 'Continuar';

  @override
  String get voidAction => 'Anular';

  @override
  String get newAction => 'Novo';

  @override
  String get returnAction => 'Devolver';

  @override
  String get alreadyInModule => 'Você já está no módulo desejado';

  @override
  String get wholesalePriceLabel => 'Preço atacado';

  @override
  String get replacementCostPrefix => 'Custo de reposição ';

  @override
  String get pricePrefix => 'Preço ';

  @override
  String get currentStockPrefix => 'Estoque atual ';

  @override
  String get availableForSale => 'Saldo de venda';

  @override
  String get retailPrefix => 'Varejo ';

  @override
  String get minimumRetailPrefix => 'Mín varejo ';

  @override
  String get minimumRetailOfferPrefix => 'Mín varejo oferta ';

  @override
  String get minimumWholesalePrefix => 'Mín atacado ';

  @override
  String get wholesaleOfferPrefix => 'Oferta atacado ';

  @override
  String get minimumEcommercePrefix => 'Mín ecommerce ';

  @override
  String get minimumEcommerceOfferPrefix => 'Mín ecommerce oferta ';

  @override
  String get selectedCompanyAddress => 'Endereço na empresa selecionada';

  @override
  String get timeLabel => 'Horário';

  @override
  String get endOfferAction => 'Encerrar';

  @override
  String get paymentExceedsOrder =>
      'O total das formas de pagamento está maior que o total dos produtos!\n';

  @override
  String get customerSearchHint => 'Nome|Cód|CPF/CNPJ';

  @override
  String get orderChangeImpacts =>
      'Esta alteração terá os seguintes impactos no pedido:\n\n';

  @override
  String get salesOrdersReadErrors =>
      'pedidos de vendas com erros durante a leitura';

  @override
  String get unmarkSendingAll => 'Desmarcar envio (todos)';

  @override
  String get unmarkSendingSelected => 'Desmarcar envio (selecionados)';

  @override
  String get notAuthorizer =>
      'Você não é um autorizador. Por isso não pode votar nesse processo';

  @override
  String get statusProduct => 'Status/Produto';

  @override
  String get settingsLoadFailed => 'Não foi possível carregar as configurações';

  @override
  String get autoScanExplanation =>
      'Ao ativar essa opção, a câmera será aberta automaticamente para escanear o próximo produto após confirmar uma quantidade';

  @override
  String get enteredAddresses => 'Endereços informados';

  @override
  String get privacyConsentRequired =>
      'O consentimento de privacidade é obrigatório';

  @override
  String get strokeThickness => 'Espessura do traço';

  @override
  String get barcodeRatio => 'Proporção das barras';

  @override
  String get noCameraAvailable => 'Nenhuma câmera está disponível';

  @override
  String get centerAlignment => 'Centro';

  @override
  String get printQuality => 'Qualidade da impressão';

  @override
  String get positioning => 'Posicionamento';

  @override
  String get labelSize => 'Tamanho da etiqueta';

  @override
  String get barcodeLabel => 'Código de barras';

  @override
  String get otherOption => 'Outro';

  @override
  String get paginatedForm => 'Paginado';

  @override
  String get continuousForm => 'Contínuo';

  @override
  String get centimeters => 'Centímetros';

  @override
  String get printerDots => 'Pontos da impressora';

  @override
  String get agreementLabel => 'Convênio';

  @override
  String get customerCard => 'Cartão de cliente';

  @override
  String get transportLabel => 'Transporte';

  @override
  String get salesOrderProduct => 'Produto do pedido de venda';

  @override
  String get unitaryPacking => 'Unitário';

  @override
  String get multiplePacking => 'Múltiplo';

  @override
  String get bothOptions => 'Ambos';

  @override
  String get scaleFactor => 'fator';

  @override
  String get printerCommandValue => 'valor do comando';

  @override
  String get paymentsWillBeCleared =>
      'As formas de pagamento atuais serão removidas';

  @override
  String get discountsWillBeReset => 'Os descontos serão removidos';

  @override
  String get surchargesWillBeReset => 'Os acréscimos serão removidos';

  @override
  String get deliveryFeesWillBeReset => 'As taxas de entrega serão removidas';

  @override
  String get customerBlockedForSales =>
      'O cliente selecionado possui bloqueio para vendas';

  @override
  String get automaticDiscountsWillBeRemoved =>
      'Os descontos automáticos do produto serão removidos';

  @override
  String get noBlockade => 'Nenhum';

  @override
  String get offerPriceBlockade => 'Bloqueio por preço de oferta';

  @override
  String get automaticDiscountBlockade => 'Bloqueio por desconto automático';

  @override
  String get salesAgreementBlockade => 'Bloqueio por negociação de venda';

  @override
  String get wholesalePriceBlockade => 'Bloqueio por preço de atacado';

  @override
  String get promotionOrigin => 'Promoção';

  @override
  String get salesAgreementOrigin => 'Negociação de vendas';

  @override
  String get taxExemptionOrigin => 'Desoneração';

  @override
  String get employeeBond => 'Funcionário';

  @override
  String get simpleUserBond => 'Simples';

  @override
  String get anyUserCanAuthorize => 'Qualquer usuário pode autorizar';

  @override
  String get allUsersShouldAuthorize => 'Todos os usuários devem autorizar';

  @override
  String get closedProcess => 'Processo encerrado';

  @override
  String get definedForHandler => 'Definido para o responsável';

  @override
  String get goodsReceiptDocumentValue => 'Valor do documento no recebimento';

  @override
  String get goodsReceiptDocumentCancellation =>
      'Cancelamento de documento no recebimento';

  @override
  String get goodsReceiptDocumentRelease =>
      'Liberação de documento no recebimento';

  @override
  String get goodsReceiptXmlValidation =>
      'Validação de documento XML no recebimento';

  @override
  String get goodsReceiptPaymentTermsValidation =>
      'Validação de condição de pagamento no recebimento';

  @override
  String get salesOrderBelowMinimumPrice =>
      'Pedido de venda com preço abaixo do mínimo';

  @override
  String get salesOrderExcessDiscount =>
      'Pedido de venda com desconto acima do permitido';

  @override
  String get receiptCompleted => 'Utilizado por uma entrada (Finalizado)';

  @override
  String get receiptCanceled => 'Cancelado (Finalizado)';

  @override
  String get countingReceiptProducts => 'Efetuando contagem de produtos';

  @override
  String get receiptReleasedAwaitingEntry =>
      'Liberado para entrada (Aguardando entrada)';

  @override
  String get receiptUnderAuthorization => 'Em processo de autorização';

  @override
  String get receiptAwaitingProductMaintenance =>
      'Aguardando manutenção de produtos';

  @override
  String get receiptAwaitingRelease => 'Aguardando liberação para entrada';

  @override
  String get receiptUnknownStatus => 'Status desconhecido. Avise o suporte';

  @override
  String get orderToInvoiceJudgment => 'Solicitação para nota fiscal';

  @override
  String get invoiceToCountJudgment => 'Nota fiscal para contagem';

  @override
  String get orderToCountJudgment => 'Solicitação para contagem';

  @override
  String moduleDisabledForCompany(String module) {
    return 'O módulo $module está desabilitado para essa empresa...';
  }

  @override
  String userMissingResource(String resource) {
    return 'Seu usuário não possui permissão para: $resource';
  }

  @override
  String copiedText(String text) {
    return 'Copiado: $text';
  }

  @override
  String searchProductsByType(String type) {
    return 'Consultar produtos ($type)';
  }

  @override
  String endNamedOffer(String type) {
    return 'Encerrar oferta $type';
  }

  @override
  String confirmEndNamedOffer(String type) {
    return 'Tem certeza que deseja encerrar a oferta $type?';
  }

  @override
  String paginationRange(int start, int end, int total) {
    return '$start-$end de $total';
  }

  @override
  String changeValue(String value) {
    return 'Alterar $value';
  }

  @override
  String addValue(String value) {
    return 'Adicionar $value';
  }

  @override
  String printingUpdateFailed(String error) {
    return 'Erro ao atualizar impressão: $error';
  }

  @override
  String fromStock(String stock) {
    return 'De \"$stock\"';
  }

  @override
  String toStock(String stock) {
    return 'Para \"$stock\"';
  }

  @override
  String paymentDifference(String amount) {
    return 'Diferença = $amount';
  }

  @override
  String editingOrderCode(String code) {
    return 'Alterando ($code)';
  }

  @override
  String discountWithSymbol(String symbol) {
    return 'Desconto $symbol';
  }

  @override
  String priceWithTypeAbbreviation(String type) {
    return 'Preço R\$ ($type)';
  }

  @override
  String valueWithSymbol(String symbol) {
    return 'Valor $symbol';
  }

  @override
  String printOrderCode(String code) {
    return 'Imprimir pedido $code';
  }

  @override
  String priceWithType(String type) {
    return 'Preço $type';
  }

  @override
  String companyWithCode(String code) {
    return 'Empresa $code';
  }

  @override
  String websiteProductToLink(String name) {
    return 'Produto do site \"$name\"\n';
  }

  @override
  String productToLink(String name) {
    return 'Produto a ser associado \"$name\"\n';
  }

  @override
  String spreadsheetDownloadedAt(String path) {
    return 'Planilha baixada em \"$path\"';
  }

  @override
  String salesOrderWithCode(String code) {
    return 'Pedido de venda $code';
  }

  @override
  String unsupportedAuthorizationType(String type) {
    return 'O processo de autorização de tipo \"$type\" ainda não foi implementado para ser julgado através do aplicativo';
  }

  @override
  String documentConferenceCompleted(String number) {
    return 'A conferência do documento $number foi concluída com sucesso';
  }

  @override
  String conferenceConfirmationFailed(String error) {
    return 'Houve um erro ao tentar confirmar a conferência: $error';
  }

  @override
  String customersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clientes',
      one: '$count cliente',
    );
    return '$_temp0';
  }

  @override
  String requestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count requisições',
      one: '$count requisição',
    );
    return '$_temp0';
  }

  @override
  String duplicateDataDetails(String details) {
    return 'Essa ação está duplicando dados que não podem ser duplicados. \n$details';
  }

  @override
  String cameraOpenFailed(String error) {
    return 'Não foi possível abrir a câmera: $error';
  }

  @override
  String reportId(String id) {
    return 'ID: $id';
  }

  @override
  String layoutFieldsCount(int count) {
    return 'Campos ($count)';
  }

  @override
  String labelParametersWithUnit(String unit) {
    return 'Parâmetros da etiqueta ($unit)';
  }

  @override
  String formParametersWithUnit(String unit) {
    return 'Parâmetros do formulário ($unit)';
  }

  @override
  String appVersion(String version) {
    return 'Versão $version';
  }

  @override
  String freeUntilDate(String date) {
    return 'Grátis até $date';
  }

  @override
  String formattedAddress(
    String street,
    String number,
    String district,
    String city,
    String state,
  ) {
    return '$street, número $number. $district, $city, $state';
  }

  @override
  String lastChangedQuantity(String sign) {
    return 'Última quantidade alterada $sign';
  }

  @override
  String get percentageType => 'Porcentagem';

  @override
  String get reaisType => 'Reais';

  @override
  String get withoutJudgment => 'Sem julgamento';

  @override
  String get acceptedJudgment => 'Aceito';

  @override
  String get returnAllJudgment => 'Devolver tudo';

  @override
  String get hidePasswordAction => 'Ocultar';

  @override
  String get showPasswordAction => 'Mostrar';

  @override
  String printerConnectionFailure(String error) {
    return 'Ocorreu um erro para conectar com a impressora\n\n\"$error\"\n\nConfirme se o IP da impressora está correto, se ela está com bobina e se ela está ligada. Caso não resolva, reinicie ela e tente novamente';
  }

  @override
  String orderPrintingFailure(String error) {
    return 'Ocorreu um erro ao imprimir o pedido\n\n$error';
  }

  @override
  String printedSalesOrder(String value) {
    return 'PEDIDO DE VENDA $value';
  }

  @override
  String printedAt(String value) {
    return 'Impresso em $value';
  }

  @override
  String printedOrder(String value) {
    return 'Pedido: $value';
  }

  @override
  String printedOrderNumber(String value) {
    return 'Pedido Nº: $value';
  }

  @override
  String printedOrderTemplate(String value) {
    return 'Modelo de Pedido: $value';
  }

  @override
  String printedIssueDate(String value) {
    return 'Data de Emissao: $value';
  }

  @override
  String printedCustomer(String value) {
    return 'Cliente: $value';
  }

  @override
  String printedSeller(String value) {
    return 'Vendedor: $value';
  }

  @override
  String printedUser(String value) {
    return 'Usuario: $value';
  }

  @override
  String printedSurcharge(String value) {
    return 'Acrescimo: $value';
  }

  @override
  String printedPaymentDiscount(String value) {
    return 'Desconto Financeiro: $value';
  }

  @override
  String printedPaymentSurcharge(String value) {
    return 'Acrescimo Financeiro: $value';
  }

  @override
  String printedShipping(String value) {
    return 'Frete: $value';
  }

  @override
  String printedNetTotal(String value) {
    return 'Total Liquido: R\$ $value';
  }

  @override
  String printedInstallments(String value) {
    return ' em ${value}x';
  }

  @override
  String printedDiscountAmount(String value) {
    return '  (-) Desconto: R\$ $value';
  }

  @override
  String printedSurchargeAmount(String value) {
    return '  (+) Acrescimo: R\$ $value';
  }

  @override
  String printedItemDiscount(String value) {
    return 'Desconto -$value';
  }

  @override
  String printedItemSurcharge(String value) {
    return 'Acrescimo +$value';
  }

  @override
  String printedItemShipping(String value) {
    return 'Frete +$value';
  }

  @override
  String removedPaymentMethods(String methods) {
    return 'As seguintes formas de pagamento serão removidas: $methods';
  }

  @override
  String customerSalesBlockDetails(String details) {
    return 'O cliente possui bloqueio para vendas: $details';
  }

  @override
  String confirmOrderChangeImpacts(String impacts) {
    return 'Esta alteração terá os seguintes impactos no pedido:\n\n$impacts\n\nDeseja prosseguir?';
  }

  @override
  String get layoutNameRequired =>
      'Nome: Este campo é de preenchimento obrigatório';

  @override
  String get layoutPrinterRequired =>
      'Impressora: A impressora não foi informada';

  @override
  String get layoutFormWidthInvalid =>
      'Largura do formulário: Informe um valor maior que zero';

  @override
  String get layoutFormHeightInvalid =>
      'Altura do formulário: Informe um valor maior que zero';

  @override
  String get layoutColumnsInvalid =>
      'Quantidade de colunas: Informe um valor maior que zero';

  @override
  String get layoutWidthInvalid =>
      'Largura da etiqueta: Informe um valor maior que zero';

  @override
  String get layoutHeightInvalid =>
      'Altura da etiqueta: Informe um valor maior que zero';

  @override
  String get layoutFormMarginsInvalid =>
      'As margens do formulário não podem ser negativas';

  @override
  String get layoutLabelMarginsInvalid =>
      'As margens da etiqueta não podem ser negativas';

  @override
  String get layoutTemperatureRequired =>
      'Temperatura de impressão: Selecione uma opção';

  @override
  String get layoutSpeedRequired =>
      'Velocidade de impressão: Selecione uma opção';

  @override
  String get layoutIntervalInvalid =>
      'Intervalo entre pacotes deve ser maior que zero';

  @override
  String get layoutFormSizeRequired =>
      'A configuração do tamanho do formulário deve ser aplicada';

  @override
  String get layoutAddressRequired => 'Tipo de endereço: Selecione uma opção';

  @override
  String get layoutAddressInapplicable =>
      'O tipo de endereço não se aplica ao tipo de leiaute';

  @override
  String get layoutFieldRequired =>
      'Informe pelo menos um campo para o leiaute';

  @override
  String get layoutFieldInapplicable =>
      'Existe pelo menos um campo que não se aplica ao tipo de leiaute informado';

  @override
  String get layoutLabelsExceedForm =>
      'As etiquetas não cabem na largura do formulário';

  @override
  String get noSelectedCompany =>
      'Nenhuma empresa selecionada. Carregue os dados novamente';

  @override
  String get noCameraAvailableFailure => 'Nenhuma câmera está disponível';

  @override
  String get reportContextUnavailable =>
      'Não foi possível carregar o contexto do relatório';

  @override
  String get reportSavedLayoutRequired =>
      'Somente um leiaute salvo pode ser relatado';

  @override
  String get reportImagesRequired =>
      'As duas imagens do relatório devem ser informadas';

  @override
  String get reportCategoryRequired => 'A categoria deve ser informada';

  @override
  String get reportPrivacyRequired =>
      'O consentimento de privacidade é obrigatório';

  @override
  String get processTypeUnsupported => 'Tipo de processo não implementado';

  @override
  String get reportValidationUnsupportedSchema =>
      'Versão do formato não suportada';

  @override
  String get reportValidationInvalidIdempotencyKey =>
      'A chave de identificação deve ser um UUID';

  @override
  String get reportValidationSupabaseEnterpriseRequired =>
      'A empresa do aplicativo deve ser informada';

  @override
  String get reportValidationErpEnterpriseRequired =>
      'A empresa do ERP deve ser informada';

  @override
  String get reportValidationErpUserRequired =>
      'O nome do usuário do ERP deve ser informado';

  @override
  String get reportValidationErpUserTooLong =>
      'O nome do usuário do ERP deve conter no máximo 200 caracteres';

  @override
  String get reportValidationErpCompanyRequired =>
      'O nome da empresa do ERP deve ser informado';

  @override
  String get reportValidationErpCompanyTooLong =>
      'O nome da empresa do ERP deve conter no máximo 200 caracteres';

  @override
  String get reportValidationReportDescriptionRequired =>
      'A descrição deve ser informada';

  @override
  String get reportValidationReportDescriptionTooLong =>
      'A descrição deve conter no máximo 2000 caracteres';

  @override
  String get reportValidationSavedLayoutRequired =>
      'Somente um leiaute salvo pode ser relatado';

  @override
  String get reportValidationEnvironmentRequired =>
      'Os dados do ambiente devem estar completos';

  @override
  String get reportValidationPhysicalImageTooLarge =>
      'A foto da etiqueta deve ter no máximo 5 MiB';

  @override
  String get reportValidationPhysicalImageDimensionsInvalid =>
      'As dimensões da foto da etiqueta são inválidas';

  @override
  String get reportValidationCanvasImageTooLarge =>
      'A imagem da pré-visualização deve ter no máximo 5 MiB';

  @override
  String get reportValidationCanvasImageDimensionsInvalid =>
      'As dimensões da imagem da pré-visualização são inválidas';

  @override
  String get reportValidationCapturesNotConfirmed =>
      'As duas capturas devem ser confirmadas';

  @override
  String get deactivatedProperty => 'Desativado';

  @override
  String get fiscalClassificationProperty => 'Classificacao fiscal';

  @override
  String get labelPhotoUploadTooLarge =>
      'A foto da etiqueta não pôde ser convertida dentro do limite de envio.';

  @override
  String get labelCanvasUploadTooLarge =>
      'A pré-visualização excede o limite de envio.';

  @override
  String get labelCanvasDecodeFailed =>
      'Não foi possível decodificar os pixels da pré-visualização.';

  @override
  String get labelCanvasUnreadable =>
      'A pré-visualização não é uma imagem legível.';

  @override
  String get labelCanvasWebpUnreadable =>
      'A pré-visualização convertida não é uma imagem WebP legível.';

  @override
  String get labelCanvasBlank =>
      'A pré-visualização convertida não possui conteúdo visível.';

  @override
  String get labelImageWebpUnreadable =>
      'A imagem convertida não é um arquivo WebP legível.';

  @override
  String get labelImageFileMissing =>
      'O arquivo de imagem não foi encontrado ou está vazio.';
}
