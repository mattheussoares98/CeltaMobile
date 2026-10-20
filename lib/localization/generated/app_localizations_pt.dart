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
}
