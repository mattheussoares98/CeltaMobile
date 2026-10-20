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
  cannotOpenUrl('Não foi possível abrir {url}');

  const CoreFailure(this.fallback);
  final String fallback;

  String message(List<String> arguments) => this == cannotOpenUrl
      ? fallback.replaceAll('{url}', arguments.first)
      : fallback;
}
