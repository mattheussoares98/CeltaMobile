/// Stable failure identifiers; Portuguese text remains the diagnostic fallback.
enum CoreFailure {
  invalidSession("Sessão inválida. Efetue o login novamente"),
  postalCodeNotFound("Esse CEP não foi encontrado"),
  noWorkingUrl(
    "Nenhuma URL está funcionando. Verifique sua conexão com a internet e caso esteja funcionando, entre em contato com o suporte técnico",
  ),
  unsupportedDownload(
    "Não deveria cair nesse trecho do código. Acione o suporte técnico",
  ),
  selectSaveFolder("Você precisa selecionar uma pasta para salvar o arquivo"),
  unexpectedLoginError("Ocorreu um erro não esperado para efetuar o login"),
  invalidResponseStructure("Estrutura da resposta inválida"),
  httpBadRequest("Requisição inválida"),
  httpNotFound("Recurso não encontrado"),
  httpServerError("Ocorreu um erro no servidor. Tente novamente mais tarde"),
  httpUnauthorized("Não autorizado. Por favor, faça login novamente"),
  httpForbidden("Acesso negado"),
  httpInvalidData("Dados inválidos"),
  companyNotFound('Empresa não encontrada'),
  purchasePeriodTooLong(
    'A diferença do período não pode ser maior que 90 dias',
  ),
  quotationBuyerRequired("O comprador deve ser informado"),
  quotationEnterpriseRequired("Ao menos uma empresa deve ser informada"),
  quotationProductRequired("Ao menos um produto deve ser informado"),
  priceSurveyCodeRequired(
    "Para alterar o concorrente é necessário informar o código da pesquisa",
  ),
  theQuantityCannotBeNegative("A quantidade não pode ficar negativa"),
  orderTemplateNotFound("Modelo de pedido não encontrado"),
  enterTheCustomer("Informe o cliente"),
  enterTheOrderTemplate("Informe o modelo de pedido"),
  addProductsToTheOrder2("Insira produtos no pedido"),
  invalidState("Estado inválido"),
  userDoesNotHavePermissionToAccessThisModule(
    "Usuário sem permissão para acessar este módulo",
  ),
  deletingThisDetailTypeHasNotBeenImplemented(
    "Tipo de detalhe para deletar não implementado",
  ),
  rereadingThisDetailTypeHasNotBeenImplemented(
    "Tipo de detalhe para ler novamente não implementado",
  ),
  theProductWasNotFound("O produto não foi encontrado"),
  salesOrderNotFoundSearchForOrdersAgainToCheck(
    "Pedido de venda não encontrado. Consulte os pedidos novamente para confirmar se ele está disponível",
  ),
  thisProductIsNotPendingVerification(
    "Esse produto não está pendente para conferência",
  ),
  theNewQuantityCannotBeLessThanZero(
    "A nova quantidade não pode ser menor que zero",
  ),
  reviewAllProductsBeforeVoting("Julgue todos os produtos antes de votar"),
  thereAreStillUnregisteredProductsTheyNeedToBeLinked(
    "Ainda existem produtos sem cadastros. Eles precisam ser vinculados",
  ),
  unableToLoadTheSalesOrderData(
    "Não foi possível carregar os dados do pedido de vendas",
  ),
  processNotFound("Processo não encontrado"),
  layoutNameRequired("Nome: Este campo é de preenchimento obrigatório"),
  layoutPrinterRequired("Impressora: A impressora não foi informada"),
  layoutFormWidthInvalid(
    "Largura do formulário: Informe um valor maior que zero",
  ),
  layoutFormHeightInvalid(
    "Altura do formulário: Informe um valor maior que zero",
  ),
  layoutColumnsInvalid(
    "Quantidade de colunas: Informe um valor maior que zero",
  ),
  layoutWidthInvalid("Largura da etiqueta: Informe um valor maior que zero"),
  layoutHeightInvalid("Altura da etiqueta: Informe um valor maior que zero"),
  layoutFormMarginsInvalid("As margens do formulário não podem ser negativas"),
  layoutLabelMarginsInvalid("As margens da etiqueta não podem ser negativas"),
  layoutTemperatureRequired("Temperatura de impressão: Selecione uma opção"),
  layoutSpeedRequired("Velocidade de impressão: Selecione uma opção"),
  layoutIntervalInvalid("Intervalo entre pacotes deve ser maior que zero"),
  layoutFormSizeRequired(
    "A configuração do tamanho do formulário deve ser aplicada",
  ),
  layoutAddressRequired("Tipo de endereço: Selecione uma opção"),
  layoutAddressInapplicable(
    "O tipo de endereço não se aplica ao tipo de leiaute",
  ),
  layoutFieldRequired("Informe pelo menos um campo para o leiaute"),
  layoutFieldInapplicable(
    "Existe pelo menos um campo que não se aplica ao tipo de leiaute informado",
  ),
  layoutLabelsExceedForm("As etiquetas não cabem na largura do formulário"),
  noSelectedCompany("Nenhuma empresa selecionada. Carregue os dados novamente"),
  noCameraAvailableFailure("Nenhuma câmera está disponível"),
  reportContextUnavailable("Não foi possível carregar o contexto do relatório"),
  reportSavedLayoutRequired("Somente um leiaute salvo pode ser relatado"),
  reportImagesRequired("As duas imagens do relatório devem ser informadas"),
  reportCategoryRequired("A categoria deve ser informada"),
  reportPrivacyRequired("O consentimento de privacidade é obrigatório"),
  processTypeUnsupported("Tipo de processo não implementado"),
  labelPhotoUploadTooLarge(
    "A foto da etiqueta não pôde ser convertida dentro do limite de envio.",
  ),
  labelCanvasUploadTooLarge("A pré-visualização excede o limite de envio."),
  labelCanvasDecodeFailed(
    "Não foi possível decodificar os pixels da pré-visualização.",
  ),
  labelCanvasUnreadable("A pré-visualização não é uma imagem legível."),
  labelCanvasWebpUnreadable(
    "A pré-visualização convertida não é uma imagem WebP legível.",
  ),
  labelCanvasBlank(
    "A pré-visualização convertida não possui conteúdo visível.",
  ),
  labelImageWebpUnreadable(
    "A imagem convertida não é um arquivo WebP legível.",
  ),
  labelImageFileMissing(
    "O arquivo de imagem não foi encontrado ou está vazio.",
  ),
  cannotOpenUrl('Não foi possível abrir {url}');

  const CoreFailure(this.fallback);
  final String fallback;

  String message(List<String> arguments) => this == cannotOpenUrl
      ? fallback.replaceAll('{url}', arguments.first)
      : fallback;
}
