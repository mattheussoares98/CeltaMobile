import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pt'),
    Locale('en'),
  ];

  /// Application title
  ///
  /// In pt, this message translates to:
  /// **'Celta mobile'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @portuguese.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In pt, this message translates to:
  /// **'Inglês'**
  String get english;

  /// No description provided for @signIn.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get signIn;

  /// No description provided for @enterprise.
  ///
  /// In pt, this message translates to:
  /// **'Empresa'**
  String get enterprise;

  /// No description provided for @username.
  ///
  /// In pt, this message translates to:
  /// **'Usuário'**
  String get username;

  /// No description provided for @password.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get password;

  /// No description provided for @requiredField.
  ///
  /// In pt, this message translates to:
  /// **'Campo obrigatório'**
  String get requiredField;

  /// No description provided for @error.
  ///
  /// In pt, this message translates to:
  /// **'Erro'**
  String get error;

  /// No description provided for @showPassword.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar senha'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In pt, this message translates to:
  /// **'Ocultar senha'**
  String get hidePassword;

  /// No description provided for @postalCode.
  ///
  /// In pt, this message translates to:
  /// **'CEP'**
  String get postalCode;

  /// No description provided for @searchPostalCode.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar CEP'**
  String get searchPostalCode;

  /// No description provided for @state.
  ///
  /// In pt, this message translates to:
  /// **'Estado'**
  String get state;

  /// No description provided for @reference.
  ///
  /// In pt, this message translates to:
  /// **'Referência'**
  String get reference;

  /// No description provided for @number.
  ///
  /// In pt, this message translates to:
  /// **'Número'**
  String get number;

  /// No description provided for @district.
  ///
  /// In pt, this message translates to:
  /// **'Bairro'**
  String get district;

  /// No description provided for @complement.
  ///
  /// In pt, this message translates to:
  /// **'Complemento'**
  String get complement;

  /// No description provided for @city.
  ///
  /// In pt, this message translates to:
  /// **'Cidade'**
  String get city;

  /// No description provided for @street.
  ///
  /// In pt, this message translates to:
  /// **'Logradouro'**
  String get street;

  /// No description provided for @address.
  ///
  /// In pt, this message translates to:
  /// **'Endereço'**
  String get address;

  /// No description provided for @addAddress.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar endereço'**
  String get addAddress;

  /// No description provided for @requestTemplates.
  ///
  /// In pt, this message translates to:
  /// **'Modelos de pedido'**
  String get requestTemplates;

  /// No description provided for @noRequestTemplates.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum modelo de pedido foi encontrado\n\nLembre-se que somente modelos que estão com o parâmetro \"Permitir a utilização em pedidos feitos por aplicativos\" aparecerão aqui'**
  String get noRequestTemplates;

  /// No description provided for @reload.
  ///
  /// In pt, this message translates to:
  /// **'Carregar novamente'**
  String get reload;

  /// No description provided for @defaultTemplate.
  ///
  /// In pt, this message translates to:
  /// **'Modelo padrão'**
  String get defaultTemplate;

  /// No description provided for @personalizedCode.
  ///
  /// In pt, this message translates to:
  /// **'Cód personalizado'**
  String get personalizedCode;

  /// No description provided for @code.
  ///
  /// In pt, this message translates to:
  /// **'Código'**
  String get code;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @operationType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de operação'**
  String get operationType;

  /// No description provided for @practicedPrice.
  ///
  /// In pt, this message translates to:
  /// **'Preço praticado'**
  String get practicedPrice;

  /// No description provided for @priceType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo preço'**
  String get priceType;

  /// No description provided for @canChangeCostOrSalePrice.
  ///
  /// In pt, this message translates to:
  /// **'Pode alterar preço de custo ou venda'**
  String get canChangeCostOrSalePrice;

  /// No description provided for @cannotChangeCostOrSalePrice.
  ///
  /// In pt, this message translates to:
  /// **'Não pode alterar preço de custo ou venda'**
  String get cannotChangeCostOrSalePrice;

  /// No description provided for @canChangePrice.
  ///
  /// In pt, this message translates to:
  /// **'Permite alterar o preço'**
  String get canChangePrice;

  /// No description provided for @cannotChangePrice.
  ///
  /// In pt, this message translates to:
  /// **'Não permite alterar o preço'**
  String get cannotChangePrice;

  /// No description provided for @canApplyManualDiscount.
  ///
  /// In pt, this message translates to:
  /// **'Permite desconto manual'**
  String get canApplyManualDiscount;

  /// No description provided for @cannotApplyManualDiscount.
  ///
  /// In pt, this message translates to:
  /// **'Não permite desconto manual'**
  String get cannotApplyManualDiscount;

  /// No description provided for @searchHint.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar...'**
  String get searchHint;

  /// No description provided for @search.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar'**
  String get search;

  /// No description provided for @previous.
  ///
  /// In pt, this message translates to:
  /// **'Anterior'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In pt, this message translates to:
  /// **'Próximo'**
  String get next;

  /// No description provided for @downloadAppPrompt.
  ///
  /// In pt, this message translates to:
  /// **'Faça o download do app para utilizar'**
  String get downloadAppPrompt;

  /// No description provided for @download.
  ///
  /// In pt, this message translates to:
  /// **'Baixar'**
  String get download;

  /// No description provided for @digitsOnly.
  ///
  /// In pt, this message translates to:
  /// **'Digite somente números'**
  String get digitsOnly;

  /// No description provided for @fieldTooShort.
  ///
  /// In pt, this message translates to:
  /// **'Campo muito curto'**
  String get fieldTooShort;

  /// No description provided for @invalidCpf.
  ///
  /// In pt, this message translates to:
  /// **'CPF inválido'**
  String get invalidCpf;

  /// No description provided for @invalidCnpj.
  ///
  /// In pt, this message translates to:
  /// **'CNPJ inválido'**
  String get invalidCnpj;

  /// No description provided for @invalidUrl.
  ///
  /// In pt, this message translates to:
  /// **'URL inválida'**
  String get invalidUrl;

  /// No description provided for @httpsRequired.
  ///
  /// In pt, this message translates to:
  /// **'A URL precisa ser HTTPS'**
  String get httpsRequired;

  /// No description provided for @invalidFormat.
  ///
  /// In pt, this message translates to:
  /// **'Formato inválido'**
  String get invalidFormat;

  /// No description provided for @integersOnly.
  ///
  /// In pt, this message translates to:
  /// **'Apenas números inteiros'**
  String get integersOnly;

  /// No description provided for @greaterThanZero.
  ///
  /// In pt, this message translates to:
  /// **'Deve ser maior que zero'**
  String get greaterThanZero;

  /// No description provided for @invalidEmail.
  ///
  /// In pt, this message translates to:
  /// **'Por favor, insira um e-mail válido'**
  String get invalidEmail;

  /// No description provided for @invalidAreaCode.
  ///
  /// In pt, this message translates to:
  /// **'DDD inválido'**
  String get invalidAreaCode;

  /// No description provided for @invalidDate.
  ///
  /// In pt, this message translates to:
  /// **'Data inválida'**
  String get invalidDate;

  /// No description provided for @invalidIp.
  ///
  /// In pt, this message translates to:
  /// **'Formato de IP inválido'**
  String get invalidIp;

  /// No description provided for @invalidSession.
  ///
  /// In pt, this message translates to:
  /// **'Sessão inválida. Efetue o login novamente'**
  String get invalidSession;

  /// No description provided for @postalCodeNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Esse CEP não foi encontrado'**
  String get postalCodeNotFound;

  /// No description provided for @noWorkingUrl.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma URL está funcionando. Verifique sua conexão com a internet e caso esteja funcionando, entre em contato com o suporte técnico'**
  String get noWorkingUrl;

  /// No description provided for @unsupportedDownload.
  ///
  /// In pt, this message translates to:
  /// **'Não deveria cair nesse trecho do código. Acione o suporte técnico'**
  String get unsupportedDownload;

  /// No description provided for @selectSaveFolder.
  ///
  /// In pt, this message translates to:
  /// **'Você precisa selecionar uma pasta para salvar o arquivo'**
  String get selectSaveFolder;

  /// No description provided for @sharedData.
  ///
  /// In pt, this message translates to:
  /// **'Aqui estão os dados gerados pelo CeltaMobile...'**
  String get sharedData;

  /// No description provided for @unexpectedLoginError.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro não esperado para efetuar o login'**
  String get unexpectedLoginError;

  /// No description provided for @success.
  ///
  /// In pt, this message translates to:
  /// **'Sucesso'**
  String get success;

  /// No description provided for @invalidResponseStructure.
  ///
  /// In pt, this message translates to:
  /// **'Estrutura da resposta inválida'**
  String get invalidResponseStructure;

  /// No description provided for @httpBadRequest.
  ///
  /// In pt, this message translates to:
  /// **'Requisição inválida'**
  String get httpBadRequest;

  /// No description provided for @httpNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Recurso não encontrado'**
  String get httpNotFound;

  /// No description provided for @httpServerError.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro no servidor. Tente novamente mais tarde'**
  String get httpServerError;

  /// No description provided for @httpUnauthorized.
  ///
  /// In pt, this message translates to:
  /// **'Não autorizado. Por favor, faça login novamente'**
  String get httpUnauthorized;

  /// No description provided for @httpForbidden.
  ///
  /// In pt, this message translates to:
  /// **'Acesso negado'**
  String get httpForbidden;

  /// No description provided for @httpInvalidData.
  ///
  /// In pt, this message translates to:
  /// **'Dados inválidos'**
  String get httpInvalidData;

  /// No description provided for @maxDecimalPlaces.
  ///
  /// In pt, this message translates to:
  /// **'Máx {count} casas decimais'**
  String maxDecimalPlaces(int count);

  /// No description provided for @minimumLength.
  ///
  /// In pt, this message translates to:
  /// **'Precisa ter pelo menos {count} caracteres'**
  String minimumLength(int count);

  /// No description provided for @invalidDateRange.
  ///
  /// In pt, this message translates to:
  /// **'Período inválido. {start} ~ {end}'**
  String invalidDateRange(String start, String end);

  /// No description provided for @cannotOpenUrl.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir {url}'**
  String cannotOpenUrl(String url);

  /// No description provided for @coreModulesAdjustCost.
  ///
  /// In pt, this message translates to:
  /// **'Ajuste de custos'**
  String get coreModulesAdjustCost;

  /// No description provided for @coreModulesAdjustPrice.
  ///
  /// In pt, this message translates to:
  /// **'Alterar preços'**
  String get coreModulesAdjustPrice;

  /// No description provided for @coreModulesAdjustStock.
  ///
  /// In pt, this message translates to:
  /// **'Ajustar estoque'**
  String get coreModulesAdjustStock;

  /// No description provided for @coreModulesBuyQuotation.
  ///
  /// In pt, this message translates to:
  /// **'Cotação de compras'**
  String get coreModulesBuyQuotation;

  /// No description provided for @coreModulesBuyRequest.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de compras'**
  String get coreModulesBuyRequest;

  /// No description provided for @coreModulesBuyMovement.
  ///
  /// In pt, this message translates to:
  /// **'Consulta de compras'**
  String get coreModulesBuyMovement;

  /// No description provided for @coreModulesCompetingPrices.
  ///
  /// In pt, this message translates to:
  /// **'Preços concorrentes'**
  String get coreModulesCompetingPrices;

  /// No description provided for @coreModulesCustomerRegister.
  ///
  /// In pt, this message translates to:
  /// **'Cadastro de clientes'**
  String get coreModulesCustomerRegister;

  /// No description provided for @coreModulesExpeditionConference.
  ///
  /// In pt, this message translates to:
  /// **'Expedição (conferência)'**
  String get coreModulesExpeditionConference;

  /// No description provided for @coreModulesInventory.
  ///
  /// In pt, this message translates to:
  /// **'Inventário'**
  String get coreModulesInventory;

  /// No description provided for @coreModulesPrintLabel.
  ///
  /// In pt, this message translates to:
  /// **'Layout de etiquetas'**
  String get coreModulesPrintLabel;

  /// No description provided for @coreModulesProcessAuthorization.
  ///
  /// In pt, this message translates to:
  /// **'Autorização de processos'**
  String get coreModulesProcessAuthorization;

  /// No description provided for @coreModulesProductsRegister.
  ///
  /// In pt, this message translates to:
  /// **'Cadastro de produtos'**
  String get coreModulesProductsRegister;

  /// No description provided for @coreModulesReceipt.
  ///
  /// In pt, this message translates to:
  /// **'Recebimento'**
  String get coreModulesReceipt;

  /// No description provided for @coreModulesReports.
  ///
  /// In pt, this message translates to:
  /// **'Relatórios'**
  String get coreModulesReports;

  /// No description provided for @coreModulesSaleRequest.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de vendas'**
  String get coreModulesSaleRequest;

  /// No description provided for @coreModulesSearchProducts.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar produtos'**
  String get coreModulesSearchProducts;

  /// No description provided for @coreModulesSynchronizer.
  ///
  /// In pt, this message translates to:
  /// **'Sincronismo'**
  String get coreModulesSynchronizer;

  /// No description provided for @coreModulesStockReplacement.
  ///
  /// In pt, this message translates to:
  /// **'Substituição de estoque'**
  String get coreModulesStockReplacement;

  /// No description provided for @coreModulesTransferBetweenStocks.
  ///
  /// In pt, this message translates to:
  /// **'Transferência (estoques)'**
  String get coreModulesTransferBetweenStocks;

  /// No description provided for @coreModulesTransferRequest.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de transferência'**
  String get coreModulesTransferRequest;

  /// No description provided for @coreBsResourceAdjustStock.
  ///
  /// In pt, this message translates to:
  /// **'Ajuste de estoque'**
  String get coreBsResourceAdjustStock;

  /// No description provided for @coreBsResourceAdjustSalePrice.
  ///
  /// In pt, this message translates to:
  /// **'Ajuste de preços'**
  String get coreBsResourceAdjustSalePrice;

  /// No description provided for @coreBsResourceChangeSaleRequestPrices.
  ///
  /// In pt, this message translates to:
  /// **'Alterar preços no pedido de vendas'**
  String get coreBsResourceChangeSaleRequestPrices;

  /// No description provided for @coreBsResourceBuyQuotation.
  ///
  /// In pt, this message translates to:
  /// **'Cotação de compras'**
  String get coreBsResourceBuyQuotation;

  /// No description provided for @coreBsResourceBuyRequest.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de compras'**
  String get coreBsResourceBuyRequest;

  /// No description provided for @coreBsResourceTransferRequest.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de transferência'**
  String get coreBsResourceTransferRequest;

  /// No description provided for @coreBsResourceSaleRequest.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de vendas'**
  String get coreBsResourceSaleRequest;

  /// No description provided for @coreBsResourceSaleRequestChangeTPrice.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de vendas (alterar preços)'**
  String get coreBsResourceSaleRequestChangeTPrice;

  /// No description provided for @coreBsResourcePriceConference.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisa de preços'**
  String get coreBsResourcePriceConference;

  /// No description provided for @coreBsResourceResearchOfPrice.
  ///
  /// In pt, this message translates to:
  /// **'Preços concorrentes'**
  String get coreBsResourceResearchOfPrice;

  /// No description provided for @coreBsResourceSynchronizer.
  ///
  /// In pt, this message translates to:
  /// **'Monitor dos serviços de sincronização'**
  String get coreBsResourceSynchronizer;

  /// No description provided for @coreBsResourceSynchronizerDelete.
  ///
  /// In pt, this message translates to:
  /// **'Monitor dos serviços de sincronização (exclusão)'**
  String get coreBsResourceSynchronizerDelete;

  /// No description provided for @coreBsResourceGoodsReceiving.
  ///
  /// In pt, this message translates to:
  /// **'Recebimento de mercadorias'**
  String get coreBsResourceGoodsReceiving;

  /// No description provided for @coreBsResourceProcessAuthorizationRules.
  ///
  /// In pt, this message translates to:
  /// **'Regras para autorização de processos'**
  String get coreBsResourceProcessAuthorizationRules;

  /// No description provided for @corePracticedPriceTypeManual.
  ///
  /// In pt, this message translates to:
  /// **'Manual'**
  String get corePracticedPriceTypeManual;

  /// No description provided for @corePracticedPriceTypeRetail.
  ///
  /// In pt, this message translates to:
  /// **'Varejo'**
  String get corePracticedPriceTypeRetail;

  /// No description provided for @corePracticedPriceTypeWhole.
  ///
  /// In pt, this message translates to:
  /// **'Atacado'**
  String get corePracticedPriceTypeWhole;

  /// No description provided for @corePracticedPriceTypeOperationalCost.
  ///
  /// In pt, this message translates to:
  /// **'Custo operacional'**
  String get corePracticedPriceTypeOperationalCost;

  /// No description provided for @corePracticedPriceTypeReplacementCost.
  ///
  /// In pt, this message translates to:
  /// **'Custo reposição'**
  String get corePracticedPriceTypeReplacementCost;

  /// No description provided for @corePracticedPriceTypeReplacementCostMidle.
  ///
  /// In pt, this message translates to:
  /// **'Custo reposição médio'**
  String get corePracticedPriceTypeReplacementCostMidle;

  /// No description provided for @corePracticedPriceTypeLiquidCost.
  ///
  /// In pt, this message translates to:
  /// **'Custo líquido'**
  String get corePracticedPriceTypeLiquidCost;

  /// No description provided for @corePracticedPriceTypeLiquidCostMidle.
  ///
  /// In pt, this message translates to:
  /// **'Custo líquido médio'**
  String get corePracticedPriceTypeLiquidCostMidle;

  /// No description provided for @corePracticedPriceTypeDefinedBySystem.
  ///
  /// In pt, this message translates to:
  /// **'Definido pelo sistema'**
  String get corePracticedPriceTypeDefinedBySystem;

  /// No description provided for @corePracticedPriceTypeRealCost.
  ///
  /// In pt, this message translates to:
  /// **'Custo real'**
  String get corePracticedPriceTypeRealCost;

  /// No description provided for @corePracticedPriceTypeRealLiquidCost.
  ///
  /// In pt, this message translates to:
  /// **'Custo líquido real'**
  String get corePracticedPriceTypeRealLiquidCost;

  /// No description provided for @corePracticedPriceTypeFiscalCost.
  ///
  /// In pt, this message translates to:
  /// **'Custo fiscal'**
  String get corePracticedPriceTypeFiscalCost;

  /// No description provided for @corePracticedPriceTypeFiscalLiquidCost.
  ///
  /// In pt, this message translates to:
  /// **'Custo líquido fiscal'**
  String get corePracticedPriceTypeFiscalLiquidCost;

  /// No description provided for @corePracticedPriceTypeEcommerce.
  ///
  /// In pt, this message translates to:
  /// **'E-commerce'**
  String get corePracticedPriceTypeEcommerce;

  /// No description provided for @coreOperationTypeExit.
  ///
  /// In pt, this message translates to:
  /// **'Saída'**
  String get coreOperationTypeExit;

  /// No description provided for @coreOperationTypeEntrance.
  ///
  /// In pt, this message translates to:
  /// **'Entrada'**
  String get coreOperationTypeEntrance;

  /// No description provided for @coreSearchProductTypePreferenceDynamic.
  ///
  /// In pt, this message translates to:
  /// **'Dinâmico'**
  String get coreSearchProductTypePreferenceDynamic;

  /// No description provided for @coreSearchProductTypePreferencePersonalizedCode.
  ///
  /// In pt, this message translates to:
  /// **'Cód personalizado'**
  String get coreSearchProductTypePreferencePersonalizedCode;

  /// No description provided for @coreSearchProductTypePreferenceLegacyCode.
  ///
  /// In pt, this message translates to:
  /// **'Cód legado'**
  String get coreSearchProductTypePreferenceLegacyCode;

  /// No description provided for @coreSearchProductTypePreferenceEan.
  ///
  /// In pt, this message translates to:
  /// **'EAN'**
  String get coreSearchProductTypePreferenceEan;

  /// No description provided for @coreUsageTypeAdjustCost.
  ///
  /// In pt, this message translates to:
  /// **'Ajustou custo'**
  String get coreUsageTypeAdjustCost;

  /// No description provided for @coreUsageTypeAdjustSalePrice.
  ///
  /// In pt, this message translates to:
  /// **'Ajustou preço'**
  String get coreUsageTypeAdjustSalePrice;

  /// No description provided for @coreUsageTypeAdjustStock.
  ///
  /// In pt, this message translates to:
  /// **'Ajustou estoque'**
  String get coreUsageTypeAdjustStock;

  /// No description provided for @coreUsageTypeBuyMovementDetails.
  ///
  /// In pt, this message translates to:
  /// **'Consulta compra (detalhes)'**
  String get coreUsageTypeBuyMovementDetails;

  /// No description provided for @coreUsageTypeCompleteSearchSaleRequest.
  ///
  /// In pt, this message translates to:
  /// **'Consulta COMPLETA de pedido de vendas'**
  String get coreUsageTypeCompleteSearchSaleRequest;

  /// No description provided for @coreUsageTypeCountInventoryProduct.
  ///
  /// In pt, this message translates to:
  /// **'Contou produto (inventário)'**
  String get coreUsageTypeCountInventoryProduct;

  /// No description provided for @coreUsageTypeCountReceiptProduct.
  ///
  /// In pt, this message translates to:
  /// **'Contou produto (recebimento)'**
  String get coreUsageTypeCountReceiptProduct;

  /// No description provided for @coreUsageTypeDownloadReport.
  ///
  /// In pt, this message translates to:
  /// **'Baixou relatório'**
  String get coreUsageTypeDownloadReport;

  /// No description provided for @coreUsageTypeFinishedExpedition.
  ///
  /// In pt, this message translates to:
  /// **'Finalizou expedição'**
  String get coreUsageTypeFinishedExpedition;

  /// No description provided for @coreUsageTypeGenerateReport.
  ///
  /// In pt, this message translates to:
  /// **'Gerou relatório'**
  String get coreUsageTypeGenerateReport;

  /// No description provided for @coreUsageTypeInsertBuyRequest.
  ///
  /// In pt, this message translates to:
  /// **'Inseriu pedido de compra'**
  String get coreUsageTypeInsertBuyRequest;

  /// No description provided for @coreUsageTypeInsertNotFoundReceiptProduct.
  ///
  /// In pt, this message translates to:
  /// **'Inseriu produto não encontrado (recebimento)'**
  String get coreUsageTypeInsertNotFoundReceiptProduct;

  /// No description provided for @coreUsageTypeInsertSaleRequest.
  ///
  /// In pt, this message translates to:
  /// **'Inseriu pedido de venda'**
  String get coreUsageTypeInsertSaleRequest;

  /// No description provided for @coreUsageTypeInsertTransferRequest.
  ///
  /// In pt, this message translates to:
  /// **'Inseriu pedido de transferência'**
  String get coreUsageTypeInsertTransferRequest;

  /// No description provided for @coreUsageTypeInsertUpdateBuyQuotation.
  ///
  /// In pt, this message translates to:
  /// **'Inseriu/atualizou cotação de compra'**
  String get coreUsageTypeInsertUpdateBuyQuotation;

  /// No description provided for @coreUsageTypeInsertUpdateCustomer.
  ///
  /// In pt, this message translates to:
  /// **'Inseriu/atualizou cliente'**
  String get coreUsageTypeInsertUpdateCustomer;

  /// No description provided for @coreUsageTypeInsertUpdateCompetingPrices.
  ///
  /// In pt, this message translates to:
  /// **'Atualizou preços concorrentes'**
  String get coreUsageTypeInsertUpdateCompetingPrices;

  /// No description provided for @coreUsageTypeLiberateReceiptDocument.
  ///
  /// In pt, this message translates to:
  /// **'Liberou recebimento'**
  String get coreUsageTypeLiberateReceiptDocument;

  /// No description provided for @coreUsageTypeNotDefined.
  ///
  /// In pt, this message translates to:
  /// **'Não definido'**
  String get coreUsageTypeNotDefined;

  /// No description provided for @coreUsageTypeUpdateSaleRequest.
  ///
  /// In pt, this message translates to:
  /// **'Alterou pedido de vendas'**
  String get coreUsageTypeUpdateSaleRequest;

  /// No description provided for @coreUsageTypePrintLabelCreateUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Criou/atualizou etiqueta'**
  String get coreUsageTypePrintLabelCreateUpdate;

  /// No description provided for @coreUsageTypeProcessAuthorizationVote.
  ///
  /// In pt, this message translates to:
  /// **'Votou (processo de autorização)'**
  String get coreUsageTypeProcessAuthorizationVote;

  /// No description provided for @coreUsageTypeSearchProducts.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisou produtos'**
  String get coreUsageTypeSearchProducts;

  /// No description provided for @coreUsageTypeSendToPrint.
  ///
  /// In pt, this message translates to:
  /// **'Marcou p/ impressão'**
  String get coreUsageTypeSendToPrint;

  /// No description provided for @coreUsageTypeShallowBuyMovement.
  ///
  /// In pt, this message translates to:
  /// **'Consulta compras (superficial)'**
  String get coreUsageTypeShallowBuyMovement;

  /// No description provided for @coreUsageTypeShallowSearchProduct.
  ///
  /// In pt, this message translates to:
  /// **'Consulta produtos (superficial)'**
  String get coreUsageTypeShallowSearchProduct;

  /// No description provided for @coreUsageTypeShallowSearchSaleRequest.
  ///
  /// In pt, this message translates to:
  /// **'Consulta SIMPLES de pedido de vendas'**
  String get coreUsageTypeShallowSearchSaleRequest;

  /// No description provided for @coreUsageTypeStockReplacement.
  ///
  /// In pt, this message translates to:
  /// **'Substituiu estoque'**
  String get coreUsageTypeStockReplacement;

  /// No description provided for @coreUsageTypeSynchronizer.
  ///
  /// In pt, this message translates to:
  /// **'Sincronismo (manipulou)'**
  String get coreUsageTypeSynchronizer;

  /// No description provided for @coreUsageTypeTransferBetweenStocks.
  ///
  /// In pt, this message translates to:
  /// **'Transferiu entre estoques'**
  String get coreUsageTypeTransferBetweenStocks;

  /// No description provided for @coreCustomerPersonTypeFisica.
  ///
  /// In pt, this message translates to:
  /// **'Pessoa física'**
  String get coreCustomerPersonTypeFisica;

  /// No description provided for @coreCustomerPersonTypeJuridica.
  ///
  /// In pt, this message translates to:
  /// **'Pessoa jurídica'**
  String get coreCustomerPersonTypeJuridica;

  /// No description provided for @coreSearchProductCompetingPriceTypeAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get coreSearchProductCompetingPriceTypeAll;

  /// No description provided for @coreSearchProductCompetingPriceTypeInformedPrices.
  ///
  /// In pt, this message translates to:
  /// **'Já informados'**
  String get coreSearchProductCompetingPriceTypeInformedPrices;

  /// No description provided for @coreSearchProductCompetingPriceTypeNotInformedPrices.
  ///
  /// In pt, this message translates to:
  /// **'Não informados'**
  String get coreSearchProductCompetingPriceTypeNotInformedPrices;

  /// No description provided for @coreCustomerSexTypeMale.
  ///
  /// In pt, this message translates to:
  /// **'Masculino'**
  String get coreCustomerSexTypeMale;

  /// No description provided for @coreCustomerSexTypeFemale.
  ///
  /// In pt, this message translates to:
  /// **'Feminino'**
  String get coreCustomerSexTypeFemale;

  /// No description provided for @coreTransferJustificationTypeAdjustStock.
  ///
  /// In pt, this message translates to:
  /// **'Ajuste de estoque'**
  String get coreTransferJustificationTypeAdjustStock;

  /// No description provided for @coreTransferJustificationTypeTransferBetweenStocks.
  ///
  /// In pt, this message translates to:
  /// **'Transferência entre estoques'**
  String get coreTransferJustificationTypeTransferBetweenStocks;

  /// No description provided for @share.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar'**
  String get share;

  /// No description provided for @stockRequired.
  ///
  /// In pt, this message translates to:
  /// **'Estoque obrigatório'**
  String get stockRequired;

  /// No description provided for @destinationStock.
  ///
  /// In pt, this message translates to:
  /// **'Estoque de destino'**
  String get destinationStock;

  /// No description provided for @adjustmentCompleted.
  ///
  /// In pt, this message translates to:
  /// **'Ajuste efetuado com sucesso'**
  String get adjustmentCompleted;

  /// No description provided for @replacementCost.
  ///
  /// In pt, this message translates to:
  /// **'Custo de reposição'**
  String get replacementCost;

  /// No description provided for @changeReplacementCost.
  ///
  /// In pt, this message translates to:
  /// **'Alterar custo de reposição'**
  String get changeReplacementCost;

  /// No description provided for @confirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @confirmQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar?'**
  String get confirmQuestion;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get yes;

  /// No description provided for @newPrice.
  ///
  /// In pt, this message translates to:
  /// **'Novo preço'**
  String get newPrice;

  /// No description provided for @startBeforeEnd.
  ///
  /// In pt, this message translates to:
  /// **'A data de início precisa ser anterior a data de término'**
  String get startBeforeEnd;

  /// No description provided for @endAfterStart.
  ///
  /// In pt, this message translates to:
  /// **'A data de término precisa ser após a data de início'**
  String get endAfterStart;

  /// No description provided for @startDate.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In pt, this message translates to:
  /// **'Término'**
  String get endDate;

  /// No description provided for @saleType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de venda'**
  String get saleType;

  /// No description provided for @priceTypeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de preço'**
  String get priceTypeLabel;

  /// No description provided for @replicationParameters.
  ///
  /// In pt, this message translates to:
  /// **'Parâmetros de replicação'**
  String get replicationParameters;

  /// No description provided for @loadSchedules.
  ///
  /// In pt, this message translates to:
  /// **'Obter agendamentos'**
  String get loadSchedules;

  /// No description provided for @refreshSchedules.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar agendamentos'**
  String get refreshSchedules;

  /// No description provided for @noSchedulesFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum agendamento foi encontrado'**
  String get noSchedulesFound;

  /// No description provided for @createdBy.
  ///
  /// In pt, this message translates to:
  /// **'Criado por'**
  String get createdBy;

  /// No description provided for @origin.
  ///
  /// In pt, this message translates to:
  /// **'Origem'**
  String get origin;

  /// No description provided for @changedOn.
  ///
  /// In pt, this message translates to:
  /// **'Alterado em'**
  String get changedOn;

  /// No description provided for @scheduledFor.
  ///
  /// In pt, this message translates to:
  /// **'Será executado em'**
  String get scheduledFor;

  /// No description provided for @changedByClass.
  ///
  /// In pt, this message translates to:
  /// **'Alterado via classe'**
  String get changedByClass;

  /// No description provided for @changedByPackings.
  ///
  /// In pt, this message translates to:
  /// **'Alterado por embalagens'**
  String get changedByPackings;

  /// No description provided for @changedByGrid.
  ///
  /// In pt, this message translates to:
  /// **'Alterado por grade'**
  String get changedByGrid;

  /// No description provided for @willUpdateClassPrice.
  ///
  /// In pt, this message translates to:
  /// **'Vai alterar o preço da classe'**
  String get willUpdateClassPrice;

  /// No description provided for @willUpdateOperationalGroupPrice.
  ///
  /// In pt, this message translates to:
  /// **'Vai alterar preço do agrupamento operacional das empresas'**
  String get willUpdateOperationalGroupPrice;

  /// No description provided for @currentPrice.
  ///
  /// In pt, this message translates to:
  /// **'Praticado'**
  String get currentPrice;

  /// No description provided for @suggestedPrice.
  ///
  /// In pt, this message translates to:
  /// **'Sugerido'**
  String get suggestedPrice;

  /// No description provided for @minimumPrice.
  ///
  /// In pt, this message translates to:
  /// **'Mínimo'**
  String get minimumPrice;

  /// No description provided for @belowMinimum.
  ///
  /// In pt, this message translates to:
  /// **' MENOR QUE O MÍNIMO'**
  String get belowMinimum;

  /// No description provided for @priceAdjustmentProducts.
  ///
  /// In pt, this message translates to:
  /// **'Produtos (ajuste de preços)'**
  String get priceAdjustmentProducts;

  /// No description provided for @priceChangedSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Preço alterado com sucesso'**
  String get priceChangedSuccessfully;

  /// No description provided for @attention.
  ///
  /// In pt, this message translates to:
  /// **'Atenção!'**
  String get attention;

  /// No description provided for @selectJustificationAndStock.
  ///
  /// In pt, this message translates to:
  /// **'Você precisa selecionar a justificativa e o estoque!'**
  String get selectJustificationAndStock;

  /// No description provided for @justificationRequired.
  ///
  /// In pt, this message translates to:
  /// **'Justificativa obrigatória'**
  String get justificationRequired;

  /// No description provided for @justifications.
  ///
  /// In pt, this message translates to:
  /// **'Justificativas'**
  String get justifications;

  /// No description provided for @noJustification.
  ///
  /// In pt, this message translates to:
  /// **'Sem justificativa'**
  String get noJustification;

  /// No description provided for @noOrigin.
  ///
  /// In pt, this message translates to:
  /// **'Sem origem'**
  String get noOrigin;

  /// No description provided for @quantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade'**
  String get quantity;

  /// No description provided for @noPurchasesFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma compra foi encontrada'**
  String get noPurchasesFound;

  /// No description provided for @purchaseNotFound.
  ///
  /// In pt, this message translates to:
  /// **'A compra não foi encontrada'**
  String get purchaseNotFound;

  /// No description provided for @purchaseDetails.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes da compra'**
  String get purchaseDetails;

  /// No description provided for @backToTop.
  ///
  /// In pt, this message translates to:
  /// **'Voltar ao topo'**
  String get backToTop;

  /// No description provided for @document.
  ///
  /// In pt, this message translates to:
  /// **'Documento'**
  String get document;

  /// No description provided for @entranceUser.
  ///
  /// In pt, this message translates to:
  /// **'Usuário de entrada'**
  String get entranceUser;

  /// No description provided for @createdOn.
  ///
  /// In pt, this message translates to:
  /// **'Criado em'**
  String get createdOn;

  /// No description provided for @issuedOn.
  ///
  /// In pt, this message translates to:
  /// **'Emitido em'**
  String get issuedOn;

  /// No description provided for @receivedOn.
  ///
  /// In pt, this message translates to:
  /// **'Entrada em'**
  String get receivedOn;

  /// No description provided for @buyers.
  ///
  /// In pt, this message translates to:
  /// **'Compradores'**
  String get buyers;

  /// No description provided for @supplier.
  ///
  /// In pt, this message translates to:
  /// **'Fornecedor'**
  String get supplier;

  /// No description provided for @orders.
  ///
  /// In pt, this message translates to:
  /// **'Pedidos'**
  String get orders;

  /// No description provided for @netAmount.
  ///
  /// In pt, this message translates to:
  /// **'Valor líquido'**
  String get netAmount;

  /// No description provided for @notes.
  ///
  /// In pt, this message translates to:
  /// **'Observações'**
  String get notes;

  /// No description provided for @details.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes'**
  String get details;

  /// No description provided for @grossProductsServicesTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total bruto produtos/serviços'**
  String get grossProductsServicesTotal;

  /// No description provided for @totalDiscounts.
  ///
  /// In pt, this message translates to:
  /// **'Total de descontos'**
  String get totalDiscounts;

  /// No description provided for @offsets.
  ///
  /// In pt, this message translates to:
  /// **'Compensações'**
  String get offsets;

  /// No description provided for @surcharge.
  ///
  /// In pt, this message translates to:
  /// **'Acréscimo'**
  String get surcharge;

  /// No description provided for @deliveryFee.
  ///
  /// In pt, this message translates to:
  /// **'Taxa de entrega'**
  String get deliveryFee;

  /// No description provided for @icmsIssBase.
  ///
  /// In pt, this message translates to:
  /// **'Base de ICMS e ISS'**
  String get icmsIssBase;

  /// No description provided for @icmsIssAmount.
  ///
  /// In pt, this message translates to:
  /// **'Valor de ICMS e ISS'**
  String get icmsIssAmount;

  /// No description provided for @icmsStBase.
  ///
  /// In pt, this message translates to:
  /// **'Base ICMS substituto'**
  String get icmsStBase;

  /// No description provided for @invoiceIcmsStAmount.
  ///
  /// In pt, this message translates to:
  /// **'Valor ICMS substituto nota fiscal'**
  String get invoiceIcmsStAmount;

  /// No description provided for @gnreIcmsStAmount.
  ///
  /// In pt, this message translates to:
  /// **'Valor ICMS substituto GNRE'**
  String get gnreIcmsStAmount;

  /// No description provided for @fcpStAmount.
  ///
  /// In pt, this message translates to:
  /// **'Valor FCP substituto'**
  String get fcpStAmount;

  /// No description provided for @freight.
  ///
  /// In pt, this message translates to:
  /// **'Frete'**
  String get freight;

  /// No description provided for @freightInsurance.
  ///
  /// In pt, this message translates to:
  /// **'Seguro frete'**
  String get freightInsurance;

  /// No description provided for @additionalExpenses.
  ///
  /// In pt, this message translates to:
  /// **'Despesas acessórias'**
  String get additionalExpenses;

  /// No description provided for @ipi.
  ///
  /// In pt, this message translates to:
  /// **'IPI'**
  String get ipi;

  /// No description provided for @destinationIcms.
  ///
  /// In pt, this message translates to:
  /// **'ICMS destino'**
  String get destinationIcms;

  /// No description provided for @originIcms.
  ///
  /// In pt, this message translates to:
  /// **'ICMS origem'**
  String get originIcms;

  /// No description provided for @povertyReductionFund.
  ///
  /// In pt, this message translates to:
  /// **'Fundo de combate à pobreza'**
  String get povertyReductionFund;

  /// No description provided for @quantityShort.
  ///
  /// In pt, this message translates to:
  /// **'Qtd'**
  String get quantityShort;

  /// No description provided for @amount.
  ///
  /// In pt, this message translates to:
  /// **'Valor'**
  String get amount;

  /// No description provided for @total.
  ///
  /// In pt, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @cfop.
  ///
  /// In pt, this message translates to:
  /// **'CFOP'**
  String get cfop;

  /// No description provided for @companyNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Empresa não encontrada'**
  String get companyNotFound;

  /// No description provided for @purchasePeriodTooLong.
  ///
  /// In pt, this message translates to:
  /// **'A diferença do período não pode ser maior que 90 dias'**
  String get purchasePeriodTooLong;

  /// No description provided for @regularPrice.
  ///
  /// In pt, this message translates to:
  /// **'Venda'**
  String get regularPrice;

  /// No description provided for @offerPrice.
  ///
  /// In pt, this message translates to:
  /// **'Oferta'**
  String get offerPrice;

  /// No description provided for @replicateClass.
  ///
  /// In pt, this message translates to:
  /// **'Classe'**
  String get replicateClass;

  /// No description provided for @replicateGrid.
  ///
  /// In pt, this message translates to:
  /// **'Grade'**
  String get replicateGrid;

  /// No description provided for @replicateOperationalGroup.
  ///
  /// In pt, this message translates to:
  /// **'Agrupamento operacional'**
  String get replicateOperationalGroup;

  /// No description provided for @replicatePackings.
  ///
  /// In pt, this message translates to:
  /// **'Embalagens'**
  String get replicatePackings;

  /// No description provided for @noCurrentPrice.
  ///
  /// In pt, this message translates to:
  /// **'Sem preço praticado'**
  String get noCurrentPrice;

  /// No description provided for @noSuggestedPrice.
  ///
  /// In pt, this message translates to:
  /// **'Sem preço sugerido'**
  String get noSuggestedPrice;

  /// No description provided for @lastAdjustedQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Última qtd alterada {direction}'**
  String lastAdjustedQuantity(String direction);

  /// No description provided for @purchaseDetailsWithDocument.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes da compra ({document})'**
  String purchaseDetailsWithDocument(String document);

  /// No description provided for @purchaseCancelledBy.
  ///
  /// In pt, this message translates to:
  /// **'{user} cancelou essa compra'**
  String purchaseCancelledBy(String user);

  /// No description provided for @noCurrentPriceForType.
  ///
  /// In pt, this message translates to:
  /// **'Sem preço {priceType} {saleType} praticado'**
  String noCurrentPriceForType(String priceType, String saleType);

  /// No description provided for @noSuggestedPriceForType.
  ///
  /// In pt, this message translates to:
  /// **'Sem preço {priceType} {saleType} sugerido'**
  String noSuggestedPriceForType(String priceType, String saleType);

  /// No description provided for @quotations.
  ///
  /// In pt, this message translates to:
  /// **'Cotações'**
  String get quotations;

  /// No description provided for @purchaseOrderLookup.
  ///
  /// In pt, this message translates to:
  /// **'Consulta de pedidos de compras'**
  String get purchaseOrderLookup;

  /// No description provided for @noPurchaseOrdersFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum pedido de compra foi encontrado'**
  String get noPurchaseOrdersFound;

  /// No description provided for @customCode.
  ///
  /// In pt, this message translates to:
  /// **'Código personalizado'**
  String get customCode;

  /// No description provided for @creationDate.
  ///
  /// In pt, this message translates to:
  /// **'Data de criação'**
  String get creationDate;

  /// No description provided for @deadline.
  ///
  /// In pt, this message translates to:
  /// **'Data limite'**
  String get deadline;

  /// No description provided for @noDeadline.
  ///
  /// In pt, this message translates to:
  /// **'Sem data limite'**
  String get noDeadline;

  /// No description provided for @noNotes.
  ///
  /// In pt, this message translates to:
  /// **'Sem observações'**
  String get noNotes;

  /// No description provided for @creatingPriceSurvey.
  ///
  /// In pt, this message translates to:
  /// **'Inserindo pesquisa'**
  String get creatingPriceSurvey;

  /// No description provided for @editingPriceSurvey.
  ///
  /// In pt, this message translates to:
  /// **'Editando pesquisa'**
  String get editingPriceSurvey;

  /// No description provided for @insert.
  ///
  /// In pt, this message translates to:
  /// **'Inserir'**
  String get insert;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @leaveWithoutSaving.
  ///
  /// In pt, this message translates to:
  /// **'Sair sem salvar'**
  String get leaveWithoutSaving;

  /// No description provided for @unsavedChangesWarning.
  ///
  /// In pt, this message translates to:
  /// **'Caso tenha feito alguma alteração, ao sair da página sem salvar, essa alteração será perdida. Deseja sair mesmo assim?'**
  String get unsavedChangesWarning;

  /// No description provided for @inserting.
  ///
  /// In pt, this message translates to:
  /// **'Inserindo'**
  String get inserting;

  /// No description provided for @changing.
  ///
  /// In pt, this message translates to:
  /// **'Alterando'**
  String get changing;

  /// No description provided for @creatingCompetitor.
  ///
  /// In pt, this message translates to:
  /// **'Inserindo concorrente'**
  String get creatingCompetitor;

  /// No description provided for @editingCompetitor.
  ///
  /// In pt, this message translates to:
  /// **'Alterando concorrente'**
  String get editingCompetitor;

  /// No description provided for @editAddress.
  ///
  /// In pt, this message translates to:
  /// **'Inserir/alterar endereço'**
  String get editAddress;

  /// No description provided for @change.
  ///
  /// In pt, this message translates to:
  /// **'Alterar'**
  String get change;

  /// No description provided for @pricesChangedSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Preços alterados com sucesso'**
  String get pricesChangedSuccessfully;

  /// No description provided for @productAlreadyAdded.
  ///
  /// In pt, this message translates to:
  /// **'Esse produto já foi inserido!'**
  String get productAlreadyAdded;

  /// No description provided for @cannotAddQuotationProducts.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível adicionar os produtos. Entre em contato com o suporte'**
  String get cannotAddQuotationProducts;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @saveChangesPrompt.
  ///
  /// In pt, this message translates to:
  /// **'Deseja salvar as alterações?'**
  String get saveChangesPrompt;

  /// No description provided for @saveChangesQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Salvar alterações?'**
  String get saveChangesQuestion;

  /// No description provided for @confirmChanges.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar alterações'**
  String get confirmChanges;

  /// No description provided for @filterProducts.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar produtos'**
  String get filterProducts;

  /// No description provided for @associatedFilter.
  ///
  /// In pt, this message translates to:
  /// **'(associados)'**
  String get associatedFilter;

  /// No description provided for @unassociatedFilter.
  ///
  /// In pt, this message translates to:
  /// **'(não associados)'**
  String get unassociatedFilter;

  /// No description provided for @associatedOnly.
  ///
  /// In pt, this message translates to:
  /// **'Somente associados'**
  String get associatedOnly;

  /// No description provided for @loadAllUnassociatedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Consultar todos não associados'**
  String get loadAllUnassociatedProducts;

  /// No description provided for @loadAllAssociatedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Consultar todos'**
  String get loadAllAssociatedProducts;

  /// No description provided for @loadAssociatedPricedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Consultar todos já informados'**
  String get loadAssociatedPricedProducts;

  /// No description provided for @loadAssociatedUnpricedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Consultar todos não informados'**
  String get loadAssociatedUnpricedProducts;

  /// No description provided for @retailPrice.
  ///
  /// In pt, this message translates to:
  /// **'Venda'**
  String get retailPrice;

  /// No description provided for @retailOfferPrice.
  ///
  /// In pt, this message translates to:
  /// **'Venda (oferta)'**
  String get retailOfferPrice;

  /// No description provided for @wholesaleOfferPrice.
  ///
  /// In pt, this message translates to:
  /// **'Atacado (oferta)'**
  String get wholesaleOfferPrice;

  /// No description provided for @ecommercePrice.
  ///
  /// In pt, this message translates to:
  /// **'Ecommerce'**
  String get ecommercePrice;

  /// No description provided for @ecommerceOfferPrice.
  ///
  /// In pt, this message translates to:
  /// **'Ecommerce (oferta)'**
  String get ecommerceOfferPrice;

  /// No description provided for @associatedWithSurvey.
  ///
  /// In pt, this message translates to:
  /// **'Associado à pesquisa'**
  String get associatedWithSurvey;

  /// No description provided for @notAssociatedWithSurvey.
  ///
  /// In pt, this message translates to:
  /// **'Não associado à pesquisa'**
  String get notAssociatedWithSurvey;

  /// No description provided for @editCompetitor.
  ///
  /// In pt, this message translates to:
  /// **'Alterar concorrente'**
  String get editCompetitor;

  /// No description provided for @unexpectedQuotationError.
  ///
  /// In pt, this message translates to:
  /// **'Esse erro jamais deveria ocorrer. Entre em contato com o suporte técnico'**
  String get unexpectedQuotationError;

  /// No description provided for @pluOrName.
  ///
  /// In pt, this message translates to:
  /// **'PLU | Nome'**
  String get pluOrName;

  /// No description provided for @moduleDisabled.
  ///
  /// In pt, this message translates to:
  /// **'Módulo desabilitado'**
  String get moduleDisabled;

  /// No description provided for @moduleDisabledContactAdmin.
  ///
  /// In pt, this message translates to:
  /// **'O módulo está desabilitado para essa empresa. Caso queira habilitar, entre em contato com o setor administrativo'**
  String get moduleDisabledContactAdmin;

  /// No description provided for @cannotUpdateQuotationEnterprises.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível atualizar as empresas. Entre em contato com o suporte.'**
  String get cannotUpdateQuotationEnterprises;

  /// No description provided for @enterprises.
  ///
  /// In pt, this message translates to:
  /// **'Empresas'**
  String get enterprises;

  /// No description provided for @cnpj.
  ///
  /// In pt, this message translates to:
  /// **'CNPJ'**
  String get cnpj;

  /// No description provided for @buyer.
  ///
  /// In pt, this message translates to:
  /// **'Comprador'**
  String get buyer;

  /// No description provided for @selectBuyer.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um comprador'**
  String get selectBuyer;

  /// No description provided for @priceSurveys.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisas cadastradas'**
  String get priceSurveys;

  /// No description provided for @selectRequestTemplate.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um modelo de pedido'**
  String get selectRequestTemplate;

  /// No description provided for @selectSupplier.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um fornecedor'**
  String get selectSupplier;

  /// No description provided for @selectEnterprise.
  ///
  /// In pt, this message translates to:
  /// **'Selecione pelo menos uma empresa'**
  String get selectEnterprise;

  /// No description provided for @identification.
  ///
  /// In pt, this message translates to:
  /// **'Identificação'**
  String get identification;

  /// No description provided for @products.
  ///
  /// In pt, this message translates to:
  /// **'Produtos'**
  String get products;

  /// No description provided for @confirmation.
  ///
  /// In pt, this message translates to:
  /// **'Confirmação'**
  String get confirmation;

  /// No description provided for @requestTemplate.
  ///
  /// In pt, this message translates to:
  /// **'Modelo de pedido'**
  String get requestTemplate;

  /// No description provided for @changingTemplateRemovesSelection.
  ///
  /// In pt, this message translates to:
  /// **'Ao alterar o modelo, as empresas e produtos selecionados serão removidos'**
  String get changingTemplateRemovesSelection;

  /// No description provided for @selectTemplate.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um modelo'**
  String get selectTemplate;

  /// No description provided for @select.
  ///
  /// In pt, this message translates to:
  /// **'Selecione'**
  String get select;

  /// No description provided for @cost.
  ///
  /// In pt, this message translates to:
  /// **'Custo'**
  String get cost;

  /// No description provided for @clearOrder.
  ///
  /// In pt, this message translates to:
  /// **'Limpar pedido'**
  String get clearOrder;

  /// No description provided for @deleteData.
  ///
  /// In pt, this message translates to:
  /// **'Apagar dados'**
  String get deleteData;

  /// No description provided for @clearOrderConfirmation.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja remover todos dados inseridos?'**
  String get clearOrderConfirmation;

  /// No description provided for @restrictedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Produtos restringidos'**
  String get restrictedProducts;

  /// No description provided for @unrestrictedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Produtos não restringidos'**
  String get unrestrictedProducts;

  /// No description provided for @editPriceSurvey.
  ///
  /// In pt, this message translates to:
  /// **'Alterar pesquisa'**
  String get editPriceSurvey;

  /// No description provided for @customCodePrefix.
  ///
  /// In pt, this message translates to:
  /// **'Cód personalizado: '**
  String get customCodePrefix;

  /// No description provided for @deliveredOn.
  ///
  /// In pt, this message translates to:
  /// **'Entregue em'**
  String get deliveredOn;

  /// No description provided for @removeEnterpriseQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Remover empresa?'**
  String get removeEnterpriseQuestion;

  /// No description provided for @removeEnterpriseProductsWarning.
  ///
  /// In pt, this message translates to:
  /// **'Há produtos informados para essa empresa. Ao remover ela, os produtos serão removidos também'**
  String get removeEnterpriseProductsWarning;

  /// No description provided for @remove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get remove;

  /// No description provided for @tradeName.
  ///
  /// In pt, this message translates to:
  /// **'Nome fantasia'**
  String get tradeName;

  /// No description provided for @searchSuppliersQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Consultar fornecedores?'**
  String get searchSuppliersQuestion;

  /// No description provided for @supplierSearchRemovesSelection.
  ///
  /// In pt, this message translates to:
  /// **'Ao consultar os fornecedores, todas empresas e produtos selecionados serão removidos!'**
  String get supplierSearchRemovesSelection;

  /// No description provided for @query.
  ///
  /// In pt, this message translates to:
  /// **'Consultar'**
  String get query;

  /// No description provided for @suppliers.
  ///
  /// In pt, this message translates to:
  /// **'Fornecedores'**
  String get suppliers;

  /// No description provided for @changeSupplierQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Alterar fornecedor?'**
  String get changeSupplierQuestion;

  /// No description provided for @changingSupplierRemovesSelection.
  ///
  /// In pt, this message translates to:
  /// **'Ao alterar o fornecedor, todas empresas e produtos selecionados serão removidos'**
  String get changingSupplierRemovesSelection;

  /// No description provided for @addProduct.
  ///
  /// In pt, this message translates to:
  /// **'Adicione pelo menos um produto'**
  String get addProduct;

  /// No description provided for @saveOrderQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Salvar pedido?'**
  String get saveOrderQuestion;

  /// No description provided for @orderSavedSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Pedido salvo com sucesso'**
  String get orderSavedSuccessfully;

  /// No description provided for @add.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get add;

  /// No description provided for @cpfCnpj.
  ///
  /// In pt, this message translates to:
  /// **'CPF/CNPJ'**
  String get cpfCnpj;

  /// No description provided for @tradeType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo comércio'**
  String get tradeType;

  /// No description provided for @quotationBuyerRequired.
  ///
  /// In pt, this message translates to:
  /// **'O comprador deve ser informado'**
  String get quotationBuyerRequired;

  /// No description provided for @quotationEnterpriseRequired.
  ///
  /// In pt, this message translates to:
  /// **'Ao menos uma empresa deve ser informada'**
  String get quotationEnterpriseRequired;

  /// No description provided for @quotationProductRequired.
  ///
  /// In pt, this message translates to:
  /// **'Ao menos um produto deve ser informado'**
  String get quotationProductRequired;

  /// No description provided for @priceSurveyCodeRequired.
  ///
  /// In pt, this message translates to:
  /// **'Para alterar o concorrente é necessário informar o código da pesquisa'**
  String get priceSurveyCodeRequired;

  /// No description provided for @priceSurveySaved.
  ///
  /// In pt, this message translates to:
  /// **'{operation, select, create{Pesquisa inserida com sucesso} other{Pesquisa alterada com sucesso}}'**
  String priceSurveySaved(String operation);

  /// No description provided for @competitorSaved.
  ///
  /// In pt, this message translates to:
  /// **'{operation, select, create{Concorrente inserido com sucesso} other{Concorrente alterado com sucesso}}'**
  String competitorSaved(String operation);

  /// No description provided for @competitorsForSurvey.
  ///
  /// In pt, this message translates to:
  /// **'Concorrentes (pesquisa {survey})'**
  String competitorsForSurvey(int survey);

  /// No description provided for @offerPriceLabel.
  ///
  /// In pt, this message translates to:
  /// **'{priceType} (oferta)'**
  String offerPriceLabel(String priceType);

  /// No description provided for @surveyCompetitorTitle.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisa {survey} - concorrente {competitor}'**
  String surveyCompetitorTitle(int survey, int competitor);

  /// No description provided for @productsCount.
  ///
  /// In pt, this message translates to:
  /// **'Produtos ({count})'**
  String productsCount(int count);

  /// No description provided for @filteredProductsCount.
  ///
  /// In pt, this message translates to:
  /// **'Produtos ({count} de {total})'**
  String filteredProductsCount(int count, int total);

  /// No description provided for @enterprisesCount.
  ///
  /// In pt, this message translates to:
  /// **'Empresas ({count})'**
  String enterprisesCount(int count);

  /// No description provided for @lastSavedOrders.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{Último pedido salvo} other{Últimos pedidos salvos}}'**
  String lastSavedOrders(int count);

  /// No description provided for @lastOrders.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{Último pedido} other{Últimos pedidos}}'**
  String lastOrders(int count);

  /// No description provided for @purchaseOrderDetailsWithCode.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes pedido ({code})'**
  String purchaseOrderDetailsWithCode(String code);

  /// No description provided for @updateBs.
  ///
  /// In pt, this message translates to:
  /// **'Atualize o BS'**
  String get updateBs;

  /// No description provided for @updateBsToUseThisFeature.
  ///
  /// In pt, this message translates to:
  /// **'A versão do BS precisa ser atualizada para utilizar essa funcionalidade'**
  String get updateBsToUseThisFeature;

  /// No description provided for @userLacksPermission.
  ///
  /// In pt, this message translates to:
  /// **'Usuário sem permissão'**
  String get userLacksPermission;

  /// No description provided for @start.
  ///
  /// In pt, this message translates to:
  /// **'Início '**
  String get start;

  /// No description provided for @end.
  ///
  /// In pt, this message translates to:
  /// **'Fim '**
  String get end;

  /// No description provided for @goToLogin.
  ///
  /// In pt, this message translates to:
  /// **'Ir para login'**
  String get goToLogin;

  /// No description provided for @goToHome.
  ///
  /// In pt, this message translates to:
  /// **'Ir para home'**
  String get goToHome;

  /// No description provided for @cameraPermission.
  ///
  /// In pt, this message translates to:
  /// **'Permissão da câmera'**
  String get cameraPermission;

  /// No description provided for @allowCameraAccessInYourDeviceSettings.
  ///
  /// In pt, this message translates to:
  /// **'Permita o acesso à câmera nas configurações do dispositivo.'**
  String get allowCameraAccessInYourDeviceSettings;

  /// No description provided for @openSettings.
  ///
  /// In pt, this message translates to:
  /// **'Abrir configurações'**
  String get openSettings;

  /// No description provided for @noProducts.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto'**
  String get noProducts;

  /// No description provided for @namePluEanScale.
  ///
  /// In pt, this message translates to:
  /// **'NOME-PLU-EAN-%-BALANÇA'**
  String get namePluEanScale;

  /// No description provided for @no.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get no;

  /// No description provided for @min.
  ///
  /// In pt, this message translates to:
  /// **' (mín'**
  String get min;

  /// No description provided for @noReplacementCost.
  ///
  /// In pt, this message translates to:
  /// **'Sem custo de reposição'**
  String get noReplacementCost;

  /// No description provided for @noPrice.
  ///
  /// In pt, this message translates to:
  /// **'Sem preço'**
  String get noPrice;

  /// No description provided for @eans.
  ///
  /// In pt, this message translates to:
  /// **'EANs'**
  String get eans;

  /// No description provided for @currentStock.
  ///
  /// In pt, this message translates to:
  /// **'Estoque Atual'**
  String get currentStock;

  /// No description provided for @noPermissionToViewStock.
  ///
  /// In pt, this message translates to:
  /// **'Sem permissão p/ ver estoque'**
  String get noPermissionToViewStock;

  /// No description provided for @noCurrentStock.
  ///
  /// In pt, this message translates to:
  /// **'Sem estoque atual'**
  String get noCurrentStock;

  /// No description provided for @noAvailableQuantityForSale.
  ///
  /// In pt, this message translates to:
  /// **'Sem saldo de venda'**
  String get noAvailableQuantityForSale;

  /// No description provided for @balance.
  ///
  /// In pt, this message translates to:
  /// **'saldo'**
  String get balance;

  /// No description provided for @offerEnded.
  ///
  /// In pt, this message translates to:
  /// **'Oferta encerrada'**
  String get offerEnded;

  /// No description provided for @offerEndedSuccessfullySearchForTheProductAgainToRefresh.
  ///
  /// In pt, this message translates to:
  /// **'Oferta encerrada com sucesso. Consulte o produto novamente para atualizar as informações'**
  String get offerEndedSuccessfullySearchForTheProductAgainToRefresh;

  /// No description provided for @stocks.
  ///
  /// In pt, this message translates to:
  /// **'Estoques'**
  String get stocks;

  /// No description provided for @latestPurchases.
  ///
  /// In pt, this message translates to:
  /// **'Últimas compras'**
  String get latestPurchases;

  /// No description provided for @date.
  ///
  /// In pt, this message translates to:
  /// **'Data'**
  String get date;

  /// No description provided for @packaging.
  ///
  /// In pt, this message translates to:
  /// **'Embalagem'**
  String get packaging;

  /// No description provided for @prices.
  ///
  /// In pt, this message translates to:
  /// **'Preços'**
  String get prices;

  /// No description provided for @addresses.
  ///
  /// In pt, this message translates to:
  /// **'Endereços'**
  String get addresses;

  /// No description provided for @purchases.
  ///
  /// In pt, this message translates to:
  /// **'Compras'**
  String get purchases;

  /// No description provided for @costs.
  ///
  /// In pt, this message translates to:
  /// **'Custos'**
  String get costs;

  /// No description provided for @margins.
  ///
  /// In pt, this message translates to:
  /// **'Margens'**
  String get margins;

  /// No description provided for @appliedPrices.
  ///
  /// In pt, this message translates to:
  /// **'Preços praticados'**
  String get appliedPrices;

  /// No description provided for @refreshPermissionToEndOffers.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar permissão para encerrar oferta'**
  String get refreshPermissionToEndOffers;

  /// No description provided for @suggestedPrices.
  ///
  /// In pt, this message translates to:
  /// **'Preços sugeridos'**
  String get suggestedPrices;

  /// No description provided for @retail.
  ///
  /// In pt, this message translates to:
  /// **'Venda '**
  String get retail;

  /// No description provided for @wholesale.
  ///
  /// In pt, this message translates to:
  /// **'Atacado '**
  String get wholesale;

  /// No description provided for @eCommerce.
  ///
  /// In pt, this message translates to:
  /// **'Ecommerce '**
  String get eCommerce;

  /// No description provided for @minimumPrices.
  ///
  /// In pt, this message translates to:
  /// **'Preços mínimos'**
  String get minimumPrices;

  /// No description provided for @info.
  ///
  /// In pt, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @net.
  ///
  /// In pt, this message translates to:
  /// **'Líquido '**
  String get net;

  /// No description provided for @averageNet.
  ///
  /// In pt, this message translates to:
  /// **'Líquido médio '**
  String get averageNet;

  /// No description provided for @tax.
  ///
  /// In pt, this message translates to:
  /// **'Fiscal '**
  String get tax;

  /// No description provided for @netTax.
  ///
  /// In pt, this message translates to:
  /// **'Fiscal líquido '**
  String get netTax;

  /// No description provided for @operating.
  ///
  /// In pt, this message translates to:
  /// **'Operacional '**
  String get operating;

  /// No description provided for @actual.
  ///
  /// In pt, this message translates to:
  /// **'Real '**
  String get actual;

  /// No description provided for @actualNet.
  ///
  /// In pt, this message translates to:
  /// **'Real líquido '**
  String get actualNet;

  /// No description provided for @replacement.
  ///
  /// In pt, this message translates to:
  /// **'Reposição '**
  String get replacement;

  /// No description provided for @averageReplacement.
  ///
  /// In pt, this message translates to:
  /// **'Reposição médio '**
  String get averageReplacement;

  /// No description provided for @noAddressesRegisteredForThisProduct.
  ///
  /// In pt, this message translates to:
  /// **'Não há endereços cadastrados para esse produto'**
  String get noAddressesRegisteredForThisProduct;

  /// No description provided for @addressEs.
  ///
  /// In pt, this message translates to:
  /// **'Endereço(s)'**
  String get addressEs;

  /// No description provided for @none.
  ///
  /// In pt, this message translates to:
  /// **'Não há'**
  String get none;

  /// No description provided for @onOffer.
  ///
  /// In pt, this message translates to:
  /// **'Em oferta'**
  String get onOffer;

  /// No description provided for @minimumWholesaleQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Qtd mín atacado'**
  String get minimumWholesaleQuantity;

  /// No description provided for @removeItem.
  ///
  /// In pt, this message translates to:
  /// **'Remover item?'**
  String get removeItem;

  /// No description provided for @quantityInCart.
  ///
  /// In pt, this message translates to:
  /// **'Qtd no carrinho'**
  String get quantityInCart;

  /// No description provided for @enteredPrice.
  ///
  /// In pt, this message translates to:
  /// **'Preço digitado'**
  String get enteredPrice;

  /// No description provided for @discount.
  ///
  /// In pt, this message translates to:
  /// **'Desconto'**
  String get discount;

  /// No description provided for @technologySolutions.
  ///
  /// In pt, this message translates to:
  /// **'Tecnologia & Soluções'**
  String get technologySolutions;

  /// No description provided for @pleaseWait.
  ///
  /// In pt, this message translates to:
  /// **'Aguarde'**
  String get pleaseWait;

  /// No description provided for @timeNotUpdated.
  ///
  /// In pt, this message translates to:
  /// **'Horário não atualizado'**
  String get timeNotUpdated;

  /// No description provided for @theTimeCannotBeEarlierThanTheMinimumDate.
  ///
  /// In pt, this message translates to:
  /// **'O horário não pode ser menor que a data mínima'**
  String get theTimeCannotBeEarlierThanTheMinimumDate;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @select2.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar'**
  String get select2;

  /// No description provided for @tryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get tryAgain;

  /// No description provided for @from.
  ///
  /// In pt, this message translates to:
  /// **'De '**
  String get from;

  /// No description provided for @to.
  ///
  /// In pt, this message translates to:
  /// **'Para '**
  String get to;

  /// No description provided for @cart.
  ///
  /// In pt, this message translates to:
  /// **'Carrinho'**
  String get cart;

  /// No description provided for @thisProductHasAZeroPriceAndTheSelectedOrder.
  ///
  /// In pt, this message translates to:
  /// **'O produto está com o preço zerado e o modelo de pedido selecionado não permite alterar o preço'**
  String get thisProductHasAZeroPriceAndTheSelectedOrder;

  /// No description provided for @plu.
  ///
  /// In pt, this message translates to:
  /// **'PLU'**
  String get plu;

  /// No description provided for @price.
  ///
  /// In pt, this message translates to:
  /// **'Preço'**
  String get price;

  /// No description provided for @noProductsAddedToTheCart.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto adicionado ao carrinho'**
  String get noProductsAddedToTheCart;

  /// No description provided for @sourceCompany.
  ///
  /// In pt, this message translates to:
  /// **'Empresa de origem'**
  String get sourceCompany;

  /// No description provided for @destinationCompany.
  ///
  /// In pt, this message translates to:
  /// **'Empresa de destino'**
  String get destinationCompany;

  /// No description provided for @theSelectedOrderTemplateDoesNotAllowPriceChanges.
  ///
  /// In pt, this message translates to:
  /// **'O modelo de pedido selecionado não permite alterar o preço'**
  String get theSelectedOrderTemplateDoesNotAllowPriceChanges;

  /// No description provided for @lastSavedOrder.
  ///
  /// In pt, this message translates to:
  /// **'Últ ped salvo'**
  String get lastSavedOrder;

  /// No description provided for @clearCart.
  ///
  /// In pt, this message translates to:
  /// **'Limpar carrinho'**
  String get clearCart;

  /// No description provided for @clearCart2.
  ///
  /// In pt, this message translates to:
  /// **'Limpar carrinho?'**
  String get clearCart2;

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @orderSearch.
  ///
  /// In pt, this message translates to:
  /// **'Busca de pedidos'**
  String get orderSearch;

  /// No description provided for @unmarkForPrinting.
  ///
  /// In pt, this message translates to:
  /// **'Desmarcar para impressão'**
  String get unmarkForPrinting;

  /// No description provided for @markForPrinting.
  ///
  /// In pt, this message translates to:
  /// **'Marcar para impressão'**
  String get markForPrinting;

  /// No description provided for @startDate2.
  ///
  /// In pt, this message translates to:
  /// **'Data início'**
  String get startDate2;

  /// No description provided for @message00000000.
  ///
  /// In pt, this message translates to:
  /// **'00/00/0000'**
  String get message00000000;

  /// No description provided for @searchFilters.
  ///
  /// In pt, this message translates to:
  /// **'Filtros de busca'**
  String get searchFilters;

  /// No description provided for @customCode2.
  ///
  /// In pt, this message translates to:
  /// **'Código Personalizado'**
  String get customCode2;

  /// No description provided for @enterTheCode.
  ///
  /// In pt, this message translates to:
  /// **'Digite o código...'**
  String get enterTheCode;

  /// No description provided for @endDate2.
  ///
  /// In pt, this message translates to:
  /// **'Data final'**
  String get endDate2;

  /// No description provided for @printJobSentSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Impressão enviada com sucesso'**
  String get printJobSentSuccessfully;

  /// No description provided for @orderDetails.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes do pedido'**
  String get orderDetails;

  /// No description provided for @unableToGenerateThePdfTryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível gerar o PDF. Tente novamente'**
  String get unableToGenerateThePdfTryAgain;

  /// No description provided for @disc.
  ///
  /// In pt, this message translates to:
  /// **'Desc'**
  String get disc;

  /// No description provided for @surch.
  ///
  /// In pt, this message translates to:
  /// **'Acrésc'**
  String get surch;

  /// No description provided for @print.
  ///
  /// In pt, this message translates to:
  /// **'Imprimir'**
  String get print;

  /// No description provided for @noPaymentDetails.
  ///
  /// In pt, this message translates to:
  /// **'Sem financeiro'**
  String get noPaymentDetails;

  /// No description provided for @paymentDetails.
  ///
  /// In pt, this message translates to:
  /// **'Financeiro'**
  String get paymentDetails;

  /// No description provided for @discounts.
  ///
  /// In pt, this message translates to:
  /// **'Descontos'**
  String get discounts;

  /// No description provided for @surcharges.
  ///
  /// In pt, this message translates to:
  /// **'Acréscimos'**
  String get surcharges;

  /// No description provided for @type.
  ///
  /// In pt, this message translates to:
  /// **'Tipo'**
  String get type;

  /// No description provided for @emails.
  ///
  /// In pt, this message translates to:
  /// **'E-mails'**
  String get emails;

  /// No description provided for @phoneNumbers.
  ///
  /// In pt, this message translates to:
  /// **'Telefones'**
  String get phoneNumbers;

  /// No description provided for @batchSentSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Lote enviado com sucesso'**
  String get batchSentSuccessfully;

  /// No description provided for @batch.
  ///
  /// In pt, this message translates to:
  /// **'Lote'**
  String get batch;

  /// No description provided for @sourceStock.
  ///
  /// In pt, this message translates to:
  /// **'Estoque de origem'**
  String get sourceStock;

  /// No description provided for @noDestination.
  ///
  /// In pt, this message translates to:
  /// **'Sem destino'**
  String get noDestination;

  /// No description provided for @sameStockAsTheSource.
  ///
  /// In pt, this message translates to:
  /// **'Estoque igual ao de origem'**
  String get sameStockAsTheSource;

  /// No description provided for @summary.
  ///
  /// In pt, this message translates to:
  /// **'Sumário'**
  String get summary;

  /// No description provided for @grossTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total bruto'**
  String get grossTotal;

  /// No description provided for @orderSurcharge.
  ///
  /// In pt, this message translates to:
  /// **'Acréscimo no pedido'**
  String get orderSurcharge;

  /// No description provided for @notAllowed.
  ///
  /// In pt, this message translates to:
  /// **'Não permitido'**
  String get notAllowed;

  /// No description provided for @orderDiscount.
  ///
  /// In pt, this message translates to:
  /// **'Desconto no pedido'**
  String get orderDiscount;

  /// No description provided for @orderDelivery.
  ///
  /// In pt, this message translates to:
  /// **'Entrega do pedido'**
  String get orderDelivery;

  /// No description provided for @totalSurcharges.
  ///
  /// In pt, this message translates to:
  /// **'Total dos acréscimos'**
  String get totalSurcharges;

  /// No description provided for @totalDiscounts2.
  ///
  /// In pt, this message translates to:
  /// **'Total dos descontos'**
  String get totalDiscounts2;

  /// No description provided for @totalDeliveryFees.
  ///
  /// In pt, this message translates to:
  /// **'Total das taxas de entrega'**
  String get totalDeliveryFees;

  /// No description provided for @netTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total líquido'**
  String get netTotal;

  /// No description provided for @salesperson.
  ///
  /// In pt, this message translates to:
  /// **'Vendedor'**
  String get salesperson;

  /// No description provided for @removeSalesperson.
  ///
  /// In pt, this message translates to:
  /// **'Remover Vendedor'**
  String get removeSalesperson;

  /// No description provided for @selectACustomer.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um cliente!'**
  String get selectACustomer;

  /// No description provided for @attention2.
  ///
  /// In pt, this message translates to:
  /// **'Atenção'**
  String get attention2;

  /// No description provided for @theOrderWasSavedSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'O pedido foi salvo com sucesso'**
  String get theOrderWasSavedSuccessfully;

  /// No description provided for @calculatePrices.
  ///
  /// In pt, this message translates to:
  /// **'Calcular preços'**
  String get calculatePrices;

  /// No description provided for @instructions.
  ///
  /// In pt, this message translates to:
  /// **'Instruções'**
  String get instructions;

  /// No description provided for @emptyBatch.
  ///
  /// In pt, this message translates to:
  /// **'Lote vazio'**
  String get emptyBatch;

  /// No description provided for @newQty.
  ///
  /// In pt, this message translates to:
  /// **'Nova qtd'**
  String get newQty;

  /// No description provided for @reason.
  ///
  /// In pt, this message translates to:
  /// **' (Justificativa)'**
  String get reason;

  /// No description provided for @request.
  ///
  /// In pt, this message translates to:
  /// **'Solicitar'**
  String get request;

  /// No description provided for @request2.
  ///
  /// In pt, this message translates to:
  /// **'Solicitar?'**
  String get request2;

  /// No description provided for @clearBatch.
  ///
  /// In pt, this message translates to:
  /// **'Limpar lote'**
  String get clearBatch;

  /// No description provided for @clearBatch2.
  ///
  /// In pt, this message translates to:
  /// **'Limpar lote?'**
  String get clearBatch2;

  /// No description provided for @searchForAProductToGetStarted.
  ///
  /// In pt, this message translates to:
  /// **'Pesquise um produto para começar'**
  String get searchForAProductToGetStarted;

  /// No description provided for @enterTheCustomer.
  ///
  /// In pt, this message translates to:
  /// **'Informe o cliente'**
  String get enterTheCustomer;

  /// No description provided for @enterAtLeastOneProduct.
  ///
  /// In pt, this message translates to:
  /// **'Informe pelo menos um produto'**
  String get enterAtLeastOneProduct;

  /// No description provided for @quantityChangedSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade alterada com sucesso'**
  String get quantityChangedSuccessfully;

  /// No description provided for @failedToAddPayment.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao adicionar pagamento'**
  String get failedToAddPayment;

  /// No description provided for @add2.
  ///
  /// In pt, this message translates to:
  /// **'ADICIONAR'**
  String get add2;

  /// No description provided for @noPaymentMethodsAreAvailableForThisOrder.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma forma de pagamento está disponível para este pedido.'**
  String get noPaymentMethodsAreAvailableForThisOrder;

  /// No description provided for @paymentMethod.
  ///
  /// In pt, this message translates to:
  /// **'Forma de pagamento'**
  String get paymentMethod;

  /// No description provided for @selectAPaymentMethod.
  ///
  /// In pt, this message translates to:
  /// **'Selecione uma forma de pagamento'**
  String get selectAPaymentMethod;

  /// No description provided for @paymentTerms.
  ///
  /// In pt, this message translates to:
  /// **'Condição de pagamento'**
  String get paymentTerms;

  /// No description provided for @noPaymentTermsAvailableOnlyPaymentTermsWithFixedInstallments.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma condição de pagamento disponível. Somente condições de pagamento com composição fixas aparecerão'**
  String get noPaymentTermsAvailableOnlyPaymentTermsWithFixedInstallments;

  /// No description provided for @toRegisterPaymentTermsWithFixedInstallmentsOpenCeltabsAnd.
  ///
  /// In pt, this message translates to:
  /// **'Para cadastrar uma condição com composição fixa, acesse o CeltaBS e vá em \"Cadastros > Financeiro > Condições de pagamento'**
  String get toRegisterPaymentTermsWithFixedInstallmentsOpenCeltabsAnd;

  /// No description provided for @noPaymentsAdded.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum pagamento adicionado'**
  String get noPaymentsAdded;

  /// No description provided for @enteredPayments.
  ///
  /// In pt, this message translates to:
  /// **'Pagamentos informados'**
  String get enteredPayments;

  /// No description provided for @newPaymentMethod.
  ///
  /// In pt, this message translates to:
  /// **'Nova forma de pagamento'**
  String get newPaymentMethod;

  /// No description provided for @missing.
  ///
  /// In pt, this message translates to:
  /// **'Faltando'**
  String get missing;

  /// No description provided for @excess.
  ///
  /// In pt, this message translates to:
  /// **'Sobrando'**
  String get excess;

  /// No description provided for @paymentSurcharge.
  ///
  /// In pt, this message translates to:
  /// **'Acréscimo financeiro'**
  String get paymentSurcharge;

  /// No description provided for @thisOrderTemplateDoesNotAllowPaymentSurcharges.
  ///
  /// In pt, this message translates to:
  /// **'Esse modelo de pedido não permite acréscimo financeiro.'**
  String get thisOrderTemplateDoesNotAllowPaymentSurcharges;

  /// No description provided for @paymentDiscount.
  ///
  /// In pt, this message translates to:
  /// **'Desconto financeiro'**
  String get paymentDiscount;

  /// No description provided for @thisOrderTemplateDoesNotAllowPaymentDiscounts.
  ///
  /// In pt, this message translates to:
  /// **'Esse modelo de pedido não permite desconto financeiro.'**
  String get thisOrderTemplateDoesNotAllowPaymentDiscounts;

  /// No description provided for @cardNumber.
  ///
  /// In pt, this message translates to:
  /// **'Número do cartão'**
  String get cardNumber;

  /// No description provided for @numberOfInstallments.
  ///
  /// In pt, this message translates to:
  /// **'Qtd parcelas'**
  String get numberOfInstallments;

  /// No description provided for @expiration.
  ///
  /// In pt, this message translates to:
  /// **'Validade'**
  String get expiration;

  /// No description provided for @selectTheCustomerSAgreementToUseThisPaymentMethod.
  ///
  /// In pt, this message translates to:
  /// **'Você só pode utilizar essa forma de pagamento se selecionar o convênio do cliente!'**
  String get selectTheCustomerSAgreementToUseThisPaymentMethod;

  /// No description provided for @customerAgreement.
  ///
  /// In pt, this message translates to:
  /// **'Convênio do cliente'**
  String get customerAgreement;

  /// No description provided for @addProductsToTheOrder.
  ///
  /// In pt, this message translates to:
  /// **'Adicione produtos no pedido!'**
  String get addProductsToTheOrder;

  /// No description provided for @creatingOrder.
  ///
  /// In pt, this message translates to:
  /// **'Inserindo pedido'**
  String get creatingOrder;

  /// No description provided for @unsavedChanges.
  ///
  /// In pt, this message translates to:
  /// **'Alterações não salvas'**
  String get unsavedChanges;

  /// No description provided for @thereAreUnsavedChangesDoYouReallyWantToLeave.
  ///
  /// In pt, this message translates to:
  /// **'Existem alterações que não foram salvas. Deseja realmente sair?'**
  String get thereAreUnsavedChangesDoYouReallyWantToLeave;

  /// No description provided for @productDetails.
  ///
  /// In pt, this message translates to:
  /// **'Detalhe do Produto'**
  String get productDetails;

  /// No description provided for @confirm2.
  ///
  /// In pt, this message translates to:
  /// **'CONFIRMAR'**
  String get confirm2;

  /// No description provided for @areYouSureYouWantToVoidThisProductS.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja anular a contagem desse produto?'**
  String get areYouSureYouWantToVoidThisProductS;

  /// No description provided for @countedQty.
  ///
  /// In pt, this message translates to:
  /// **'Qtd contada'**
  String get countedQty;

  /// No description provided for @noCountedQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Sem quantidade contada'**
  String get noCountedQuantity;

  /// No description provided for @whenEnabledFindingASingleProductAutomaticallyAddsOneUnit.
  ///
  /// In pt, this message translates to:
  /// **'Quando essa opção está ativa, ao encontrar um único produto na busca, será somado automaticamente 1 quantidade'**
  String get whenEnabledFindingASingleProductAutomaticallyAddsOneUnit;

  /// No description provided for @insertIndividually.
  ///
  /// In pt, this message translates to:
  /// **'Inserir individualmente'**
  String get insertIndividually;

  /// No description provided for @thisActionWillRemoveAllAutomaticDiscountsContinue.
  ///
  /// In pt, this message translates to:
  /// **'Esta ação irá remover todos os descontos automáticos. Deseja continuar?'**
  String get thisActionWillRemoveAllAutomaticDiscountsContinue;

  /// No description provided for @grossPrice.
  ///
  /// In pt, this message translates to:
  /// **'Preço Bruto'**
  String get grossPrice;

  /// No description provided for @totalDiscounts3.
  ///
  /// In pt, this message translates to:
  /// **'Total Descontos'**
  String get totalDiscounts3;

  /// No description provided for @netTotal2.
  ///
  /// In pt, this message translates to:
  /// **'Total Líquido'**
  String get netTotal2;

  /// No description provided for @searchByCustomCode.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar pelo código personalizado'**
  String get searchByCustomCode;

  /// No description provided for @frozenProcesses.
  ///
  /// In pt, this message translates to:
  /// **'Processos congelados'**
  String get frozenProcesses;

  /// No description provided for @stockType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de estoque'**
  String get stockType;

  /// No description provided for @personResponsible.
  ///
  /// In pt, this message translates to:
  /// **'Responsável'**
  String get personResponsible;

  /// No description provided for @frozenOn.
  ///
  /// In pt, this message translates to:
  /// **'Congelado em'**
  String get frozenOn;

  /// No description provided for @customer.
  ///
  /// In pt, this message translates to:
  /// **'Cliente'**
  String get customer;

  /// No description provided for @items.
  ///
  /// In pt, this message translates to:
  /// **'Itens'**
  String get items;

  /// No description provided for @payment.
  ///
  /// In pt, this message translates to:
  /// **'Pagamento'**
  String get payment;

  /// No description provided for @summary2.
  ///
  /// In pt, this message translates to:
  /// **'Resumo'**
  String get summary2;

  /// No description provided for @agreements.
  ///
  /// In pt, this message translates to:
  /// **'Convênios'**
  String get agreements;

  /// No description provided for @customerBlocked.
  ///
  /// In pt, this message translates to:
  /// **'Cliente Bloqueado'**
  String get customerBlocked;

  /// No description provided for @understood.
  ///
  /// In pt, this message translates to:
  /// **'Entendido'**
  String get understood;

  /// No description provided for @customerChange.
  ///
  /// In pt, this message translates to:
  /// **'Alteração do cliente'**
  String get customerChange;

  /// No description provided for @continue2.
  ///
  /// In pt, this message translates to:
  /// **'Deseja prosseguir?'**
  String get continue2;

  /// No description provided for @todaySOrders.
  ///
  /// In pt, this message translates to:
  /// **'Pedidos de hoje'**
  String get todaySOrders;

  /// No description provided for @noOrdersFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum pedido encontrado'**
  String get noOrdersFound;

  /// No description provided for @searchAgain.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar novamente'**
  String get searchAgain;

  /// No description provided for @counts.
  ///
  /// In pt, this message translates to:
  /// **'Contagens'**
  String get counts;

  /// No description provided for @noCountsFoundForThisInventoryProcessCreateAtLeast.
  ///
  /// In pt, this message translates to:
  /// **'Não foram encontradas contagens para esse processe de inventário. Crie pelo menos uma contagem'**
  String get noCountsFoundForThisInventoryProcessCreateAtLeast;

  /// No description provided for @notes2.
  ///
  /// In pt, this message translates to:
  /// **'Obs'**
  String get notes2;

  /// No description provided for @run.
  ///
  /// In pt, this message translates to:
  /// **'Executar'**
  String get run;

  /// No description provided for @selectTheCompany.
  ///
  /// In pt, this message translates to:
  /// **'Selecione a empresa'**
  String get selectTheCompany;

  /// No description provided for @orderNo.
  ///
  /// In pt, this message translates to:
  /// **'Núm pedido'**
  String get orderNo;

  /// No description provided for @totalDelivery.
  ///
  /// In pt, this message translates to:
  /// **'Total de entrega'**
  String get totalDelivery;

  /// No description provided for @totalSurcharges2.
  ///
  /// In pt, this message translates to:
  /// **'Total acréscimos'**
  String get totalSurcharges2;

  /// No description provided for @totalDiscounts4.
  ///
  /// In pt, this message translates to:
  /// **'Total descontos'**
  String get totalDiscounts4;

  /// No description provided for @unableToLoadTheOrderTryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar o pedido. Tente novamente'**
  String get unableToLoadTheOrderTryAgain;

  /// No description provided for @pdf.
  ///
  /// In pt, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @theQuantityCannotBeNegative.
  ///
  /// In pt, this message translates to:
  /// **'A quantidade não pode ficar negativa'**
  String get theQuantityCannotBeNegative;

  /// No description provided for @printerIp.
  ///
  /// In pt, this message translates to:
  /// **'IP da impressora'**
  String get printerIp;

  /// No description provided for @yourUserDoesNotHavePermissionToPerformThisAction.
  ///
  /// In pt, this message translates to:
  /// **'Seu usuário não possui permissão para realizar esse procedimento'**
  String get yourUserDoesNotHavePermissionToPerformThisAction;

  /// No description provided for @rereadAll.
  ///
  /// In pt, this message translates to:
  /// **'Reler todos'**
  String get rereadAll;

  /// No description provided for @rereadSelected.
  ///
  /// In pt, this message translates to:
  /// **'Reler selecionados'**
  String get rereadSelected;

  /// No description provided for @deleteAll.
  ///
  /// In pt, this message translates to:
  /// **'Excluir todos'**
  String get deleteAll;

  /// No description provided for @deleteSelected.
  ///
  /// In pt, this message translates to:
  /// **'Excluir selecionados'**
  String get deleteSelected;

  /// No description provided for @ignoreAll.
  ///
  /// In pt, this message translates to:
  /// **'Ignorar todos'**
  String get ignoreAll;

  /// No description provided for @ignoreSelected.
  ///
  /// In pt, this message translates to:
  /// **'Ignorar selecionados'**
  String get ignoreSelected;

  /// No description provided for @resendAll.
  ///
  /// In pt, this message translates to:
  /// **'Reenviar todos'**
  String get resendAll;

  /// No description provided for @resendSelected.
  ///
  /// In pt, this message translates to:
  /// **'Reenviar selecionados'**
  String get resendSelected;

  /// No description provided for @unmarkAll.
  ///
  /// In pt, this message translates to:
  /// **'Desmarcar todos'**
  String get unmarkAll;

  /// No description provided for @unmarkSelected.
  ///
  /// In pt, this message translates to:
  /// **'Desmarcar selecionados'**
  String get unmarkSelected;

  /// No description provided for @rereadAll2.
  ///
  /// In pt, this message translates to:
  /// **'Reler todas'**
  String get rereadAll2;

  /// No description provided for @rereadSelected2.
  ///
  /// In pt, this message translates to:
  /// **'Reler selecionadas'**
  String get rereadSelected2;

  /// No description provided for @displayingThisTypeOfErrorHasNotBeenImplementedYet.
  ///
  /// In pt, this message translates to:
  /// **'A visualização desse tipo de erro ainda não foi implementada'**
  String get displayingThisTypeOfErrorHasNotBeenImplementedYet;

  /// No description provided for @pleaseSelectACustomerBeforeSaving.
  ///
  /// In pt, this message translates to:
  /// **'Por favor, selecione um cliente antes de salvar.'**
  String get pleaseSelectACustomerBeforeSaving;

  /// No description provided for @addAtLeastOneProductToTheOrder.
  ///
  /// In pt, this message translates to:
  /// **'Adicione pelo menos um produto ao pedido.'**
  String get addAtLeastOneProductToTheOrder;

  /// No description provided for @noOrderTemplateSelectedThisIsAProgrammingErrorPlease.
  ///
  /// In pt, this message translates to:
  /// **'O modelo de pedido não está selecionado. Esse erro jamais deveria acontecer, é um erro de programação. Entre em contato com o suporte técnico'**
  String get noOrderTemplateSelectedThisIsAProgrammingErrorPlease;

  /// No description provided for @thisOrderTemplateRequiresPaymentDetailsPleaseFillInThe.
  ///
  /// In pt, this message translates to:
  /// **'O modelo de pedido obriga a que o financeiro seja informado. Por favor, preencha as formas de pagamento corretamente.'**
  String get thisOrderTemplateRequiresPaymentDetailsPleaseFillInThe;

  /// No description provided for @thisOrderTemplateDoesNotAllowPriceChangesProcessThe.
  ///
  /// In pt, this message translates to:
  /// **'O modelo de pedido não permite alterar os preços. Por isso, processe o carrinho.'**
  String get thisOrderTemplateDoesNotAllowPriceChangesProcessThe;

  /// No description provided for @yourUserDoesNotHavePermissionToChangeOrderPrices.
  ///
  /// In pt, this message translates to:
  /// **'O usuário não possui permissão para alterar os preços no pedido. Por isso, processe o carrinho'**
  String get yourUserDoesNotHavePermissionToChangeOrderPrices;

  /// No description provided for @thisOrderHasNotBeenProcessedToCalculatePricesBased.
  ///
  /// In pt, this message translates to:
  /// **'O pedido ainda não foi processado para calcular os preços de acordo com promoções, negociações de vendas, oferta, atacado, preço praticado pelo modelo de pedido, etc!\n\n Deseja salvar mesmo assim?'**
  String get thisOrderHasNotBeenProcessedToCalculatePricesBased;

  /// No description provided for @website.
  ///
  /// In pt, this message translates to:
  /// **'Site'**
  String get website;

  /// No description provided for @description.
  ///
  /// In pt, this message translates to:
  /// **'Descrição'**
  String get description;

  /// No description provided for @websiteId.
  ///
  /// In pt, this message translates to:
  /// **'ID Site'**
  String get websiteId;

  /// No description provided for @sentOn.
  ///
  /// In pt, this message translates to:
  /// **'Data envio'**
  String get sentOn;

  /// No description provided for @selectError.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar erro'**
  String get selectError;

  /// No description provided for @selectOrder.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar pedido'**
  String get selectOrder;

  /// No description provided for @lastRead.
  ///
  /// In pt, this message translates to:
  /// **'Última leitura'**
  String get lastRead;

  /// No description provided for @orderCreation.
  ///
  /// In pt, this message translates to:
  /// **'Criação do pedido'**
  String get orderCreation;

  /// No description provided for @invoice.
  ///
  /// In pt, this message translates to:
  /// **'Fatura'**
  String get invoice;

  /// No description provided for @order.
  ///
  /// In pt, this message translates to:
  /// **'Pedido'**
  String get order;

  /// No description provided for @productsNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Produtos não encontrados'**
  String get productsNotFound;

  /// No description provided for @websiteCode.
  ///
  /// In pt, this message translates to:
  /// **'Cód site'**
  String get websiteCode;

  /// No description provided for @product.
  ///
  /// In pt, this message translates to:
  /// **'Produto'**
  String get product;

  /// No description provided for @link.
  ///
  /// In pt, this message translates to:
  /// **'Associar'**
  String get link;

  /// No description provided for @searchForAndSelectTheProductToLink.
  ///
  /// In pt, this message translates to:
  /// **'Pesquise e selecione o produto a ser associado'**
  String get searchForAndSelectTheProductToLink;

  /// No description provided for @viewProduct.
  ///
  /// In pt, this message translates to:
  /// **'Consultar produto'**
  String get viewProduct;

  /// No description provided for @noProductsFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto foi encontrado'**
  String get noProductsFound;

  /// No description provided for @linkProduct.
  ///
  /// In pt, this message translates to:
  /// **'Deseja associar?'**
  String get linkProduct;

  /// No description provided for @viewOrder.
  ///
  /// In pt, this message translates to:
  /// **'Visualizar pedido'**
  String get viewOrder;

  /// No description provided for @register.
  ///
  /// In pt, this message translates to:
  /// **'Caixa'**
  String get register;

  /// No description provided for @errorDate.
  ///
  /// In pt, this message translates to:
  /// **'Data erro'**
  String get errorDate;

  /// No description provided for @cashWithdrawalDate.
  ///
  /// In pt, this message translates to:
  /// **'Data sangria'**
  String get cashWithdrawalDate;

  /// No description provided for @selectProduct.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar produto'**
  String get selectProduct;

  /// No description provided for @productIdOnWebsite.
  ///
  /// In pt, this message translates to:
  /// **'ID do Produto no Site'**
  String get productIdOnWebsite;

  /// No description provided for @errorDescription.
  ///
  /// In pt, this message translates to:
  /// **'Descrição do erro'**
  String get errorDescription;

  /// No description provided for @moreErrorInformation.
  ///
  /// In pt, this message translates to:
  /// **'Mais informações do erro'**
  String get moreErrorInformation;

  /// No description provided for @productUpload.
  ///
  /// In pt, this message translates to:
  /// **'Carga do produto'**
  String get productUpload;

  /// No description provided for @priceUpload.
  ///
  /// In pt, this message translates to:
  /// **'Carga de preços'**
  String get priceUpload;

  /// No description provided for @stockUpload.
  ///
  /// In pt, this message translates to:
  /// **'Carga de estoques'**
  String get stockUpload;

  /// No description provided for @notSentToWebsite.
  ///
  /// In pt, this message translates to:
  /// **'Não enviado ao site'**
  String get notSentToWebsite;

  /// No description provided for @sentToWebsite.
  ///
  /// In pt, this message translates to:
  /// **'Enviado ao site'**
  String get sentToWebsite;

  /// No description provided for @resend.
  ///
  /// In pt, this message translates to:
  /// **'Reenviar'**
  String get resend;

  /// No description provided for @ignored.
  ///
  /// In pt, this message translates to:
  /// **'Ignorados'**
  String get ignored;

  /// No description provided for @issueDate.
  ///
  /// In pt, this message translates to:
  /// **'Emissão'**
  String get issueDate;

  /// No description provided for @invoice2.
  ///
  /// In pt, this message translates to:
  /// **'NF'**
  String get invoice2;

  /// No description provided for @series.
  ///
  /// In pt, this message translates to:
  /// **'Série'**
  String get series;

  /// No description provided for @orderTemplateNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Modelo de pedido não encontrado'**
  String get orderTemplateNotFound;

  /// No description provided for @thisProductHasNoPrice.
  ///
  /// In pt, this message translates to:
  /// **'Esse produto não possui preço'**
  String get thisProductHasNoPrice;

  /// No description provided for @theProductSNetAmountCannotBeNegative.
  ///
  /// In pt, this message translates to:
  /// **'O valor líquido do produto não pode ser negativo.'**
  String get theProductSNetAmountCannotBeNegative;

  /// No description provided for @theProductSNetAmountMustBeGreaterThanZero.
  ///
  /// In pt, this message translates to:
  /// **'O valor líquido do produto deve ser maior que zero'**
  String get theProductSNetAmountMustBeGreaterThanZero;

  /// No description provided for @theProductSNetAmountMustBeGreaterThanZero2.
  ///
  /// In pt, this message translates to:
  /// **'O valor líquido do produto deve ser maior que zero.'**
  String get theProductSNetAmountMustBeGreaterThanZero2;

  /// No description provided for @unexpectedError.
  ///
  /// In pt, this message translates to:
  /// **'Erro não esperado'**
  String get unexpectedError;

  /// No description provided for @amountExceedsTheAvailableBalance.
  ///
  /// In pt, this message translates to:
  /// **'Valor excede o disponível'**
  String get amountExceedsTheAvailableBalance;

  /// No description provided for @selectAnAgreement.
  ///
  /// In pt, this message translates to:
  /// **'Selecione um convênio'**
  String get selectAnAgreement;

  /// No description provided for @theOrderTemplateDoesNotAllowPaymentSurcharges.
  ///
  /// In pt, this message translates to:
  /// **'O modelo de pedido não permite acréscimo financeiro'**
  String get theOrderTemplateDoesNotAllowPaymentSurcharges;

  /// No description provided for @theAmountMustBeGreaterThanZero.
  ///
  /// In pt, this message translates to:
  /// **'O valor deve ser maior que zero'**
  String get theAmountMustBeGreaterThanZero;

  /// No description provided for @selectTheSurchargeType.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o tipo de acréscimo'**
  String get selectTheSurchargeType;

  /// No description provided for @theOrderTemplateDoesNotAllowPaymentDiscounts.
  ///
  /// In pt, this message translates to:
  /// **'O modelo de pedido não permite desconto financeiro'**
  String get theOrderTemplateDoesNotAllowPaymentDiscounts;

  /// No description provided for @selectTheDiscountType.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o tipo de desconto'**
  String get selectTheDiscountType;

  /// No description provided for @manualDiscount.
  ///
  /// In pt, this message translates to:
  /// **'Desconto manual'**
  String get manualDiscount;

  /// No description provided for @invalidState.
  ///
  /// In pt, this message translates to:
  /// **'Estado inválido'**
  String get invalidState;

  /// No description provided for @addProductsToTheOrder2.
  ///
  /// In pt, this message translates to:
  /// **'Insira produtos no pedido'**
  String get addProductsToTheOrder2;

  /// No description provided for @enterTheOrderTemplate.
  ///
  /// In pt, this message translates to:
  /// **'Informe o modelo de pedido'**
  String get enterTheOrderTemplate;

  /// No description provided for @selectTheWebsite.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o site'**
  String get selectTheWebsite;

  /// No description provided for @orderId.
  ///
  /// In pt, this message translates to:
  /// **'ID do pedido'**
  String get orderId;

  /// No description provided for @addForRereading.
  ///
  /// In pt, this message translates to:
  /// **'Inserir para releitura'**
  String get addForRereading;

  /// No description provided for @customerName.
  ///
  /// In pt, this message translates to:
  /// **'Nome cliente'**
  String get customerName;

  /// No description provided for @registrationDate.
  ///
  /// In pt, this message translates to:
  /// **'Data cadastro'**
  String get registrationDate;

  /// No description provided for @customerCode.
  ///
  /// In pt, this message translates to:
  /// **'Cód cliente'**
  String get customerCode;

  /// No description provided for @selectReceipt.
  ///
  /// In pt, this message translates to:
  /// **'Selecionar cupom'**
  String get selectReceipt;

  /// No description provided for @saleDate.
  ///
  /// In pt, this message translates to:
  /// **'Dia da venda'**
  String get saleDate;

  /// No description provided for @receipt.
  ///
  /// In pt, this message translates to:
  /// **'Cupom'**
  String get receipt;

  /// No description provided for @pos.
  ///
  /// In pt, this message translates to:
  /// **'PDV'**
  String get pos;

  /// No description provided for @creation.
  ///
  /// In pt, this message translates to:
  /// **'Criação'**
  String get creation;

  /// No description provided for @openingClosing.
  ///
  /// In pt, this message translates to:
  /// **'Abertura/Fechamento'**
  String get openingClosing;

  /// No description provided for @noCustomersFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum cliente foi encontrado'**
  String get noCustomersFound;

  /// No description provided for @theEnteredDocumentNumberWasNotFound.
  ///
  /// In pt, this message translates to:
  /// **'o número de documento informado não foi encontrado'**
  String get theEnteredDocumentNumberWasNotFound;

  /// No description provided for @noErrorsFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum erro foi encontrado'**
  String get noErrorsFound;

  /// No description provided for @reload2.
  ///
  /// In pt, this message translates to:
  /// **'Recarregar'**
  String get reload2;

  /// No description provided for @message404PageNotFound.
  ///
  /// In pt, this message translates to:
  /// **'404 - Página não encontrada!'**
  String get message404PageNotFound;

  /// No description provided for @anErrorOccurred.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro'**
  String get anErrorOccurred;

  /// No description provided for @userDoesNotHavePermissionToAccessThisModule.
  ///
  /// In pt, this message translates to:
  /// **'Usuário sem permissão para acessar este módulo'**
  String get userDoesNotHavePermissionToAccessThisModule;

  /// No description provided for @rereadingThisDetailTypeHasNotBeenImplemented.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de detalhe para ler novamente não implementado'**
  String get rereadingThisDetailTypeHasNotBeenImplemented;

  /// No description provided for @deletingThisDetailTypeHasNotBeenImplemented.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de detalhe para deletar não implementado'**
  String get deletingThisDetailTypeHasNotBeenImplemented;

  /// No description provided for @productDetails2.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes do produto'**
  String get productDetails2;

  /// No description provided for @searchProperty.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar propriedade...'**
  String get searchProperty;

  /// No description provided for @notImplementedYet.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não implementado'**
  String get notImplementedYet;

  /// No description provided for @theProductWasNotFound.
  ///
  /// In pt, this message translates to:
  /// **'O produto não foi encontrado'**
  String get theProductWasNotFound;

  /// No description provided for @notProvided.
  ///
  /// In pt, this message translates to:
  /// **'Nao informada'**
  String get notProvided;

  /// No description provided for @notProvided2.
  ///
  /// In pt, this message translates to:
  /// **'Nao informado'**
  String get notProvided2;

  /// No description provided for @notProvided3.
  ///
  /// In pt, this message translates to:
  /// **'Não informada'**
  String get notProvided3;

  /// No description provided for @notProvided4.
  ///
  /// In pt, this message translates to:
  /// **'Não informado'**
  String get notProvided4;

  /// No description provided for @paymentMethods.
  ///
  /// In pt, this message translates to:
  /// **'Formas de Pagamento'**
  String get paymentMethods;

  /// No description provided for @itemTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total do item'**
  String get itemTotal;

  /// No description provided for @subtotalR.
  ///
  /// In pt, this message translates to:
  /// **'Subtotal R\$'**
  String get subtotalR;

  /// No description provided for @totalDiscountsR.
  ///
  /// In pt, this message translates to:
  /// **'Total descontos R\$'**
  String get totalDiscountsR;

  /// No description provided for @totalSurchargesR.
  ///
  /// In pt, this message translates to:
  /// **'Total acrescimos R\$'**
  String get totalSurchargesR;

  /// No description provided for @totalShippingR.
  ///
  /// In pt, this message translates to:
  /// **'Total frete R\$'**
  String get totalShippingR;

  /// No description provided for @totalR.
  ///
  /// In pt, this message translates to:
  /// **'TOTAL R\$ '**
  String get totalR;

  /// No description provided for @notes3.
  ///
  /// In pt, this message translates to:
  /// **'Observacoes '**
  String get notes3;

  /// No description provided for @instructions2.
  ///
  /// In pt, this message translates to:
  /// **'Instrucoes '**
  String get instructions2;

  /// No description provided for @salesOrderNotFoundSearchForOrdersAgainToCheck.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de venda não encontrado. Consulte os pedidos novamente para confirmar se ele está disponível'**
  String get salesOrderNotFoundSearchForOrdersAgainToCheck;

  /// No description provided for @developedByCeltaware.
  ///
  /// In pt, this message translates to:
  /// **'Desenvolvido por Celtaware'**
  String get developedByCeltaware;

  /// No description provided for @orderTemplate.
  ///
  /// In pt, this message translates to:
  /// **'Modelo de Pedido:'**
  String get orderTemplate;

  /// No description provided for @issueDate2.
  ///
  /// In pt, this message translates to:
  /// **'Data de Emissão:'**
  String get issueDate2;

  /// No description provided for @paymentDiscount2.
  ///
  /// In pt, this message translates to:
  /// **'Desconto Financeiro:'**
  String get paymentDiscount2;

  /// No description provided for @paymentSurcharge2.
  ///
  /// In pt, this message translates to:
  /// **'Acréscimo Financeiro:'**
  String get paymentSurcharge2;

  /// No description provided for @discount2.
  ///
  /// In pt, this message translates to:
  /// **'Desconto:'**
  String get discount2;

  /// No description provided for @surcharge2.
  ///
  /// In pt, this message translates to:
  /// **'Acréscimo:'**
  String get surcharge2;

  /// No description provided for @shipping.
  ///
  /// In pt, this message translates to:
  /// **'Frete:'**
  String get shipping;

  /// No description provided for @netTotal3.
  ///
  /// In pt, this message translates to:
  /// **'Total Líquido:'**
  String get netTotal3;

  /// No description provided for @instructions3.
  ///
  /// In pt, this message translates to:
  /// **'Instruções:'**
  String get instructions3;

  /// No description provided for @notes4.
  ///
  /// In pt, this message translates to:
  /// **'Observações:'**
  String get notes4;

  /// No description provided for @surch2.
  ///
  /// In pt, this message translates to:
  /// **'Acrés'**
  String get surch2;

  /// No description provided for @installments.
  ///
  /// In pt, this message translates to:
  /// **'Parcelas'**
  String get installments;

  /// No description provided for @immediatePayment.
  ///
  /// In pt, this message translates to:
  /// **'À vista'**
  String get immediatePayment;

  /// No description provided for @suspended.
  ///
  /// In pt, this message translates to:
  /// **'Suspenso'**
  String get suspended;

  /// No description provided for @signOut.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get signOut;

  /// No description provided for @areYouSureYouWantToSignOut.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja sair?'**
  String get areYouSureYouWantToSignOut;

  /// No description provided for @create.
  ///
  /// In pt, this message translates to:
  /// **'Criar'**
  String get create;

  /// No description provided for @createSalesOrders.
  ///
  /// In pt, this message translates to:
  /// **'Crie pedidos de venda'**
  String get createSalesOrders;

  /// No description provided for @searchSalesOrders.
  ///
  /// In pt, this message translates to:
  /// **'Pesquise pedidos de vendas'**
  String get searchSalesOrders;

  /// No description provided for @createPurchaseOrders.
  ///
  /// In pt, this message translates to:
  /// **'Crie pedido de compras'**
  String get createPurchaseOrders;

  /// No description provided for @searchPurchaseOrders.
  ///
  /// In pt, this message translates to:
  /// **'Pesquise pedidos de compras'**
  String get searchPurchaseOrders;

  /// No description provided for @authorized.
  ///
  /// In pt, this message translates to:
  /// **'Autorizado'**
  String get authorized;

  /// No description provided for @unauthorized.
  ///
  /// In pt, this message translates to:
  /// **'Não autorizado'**
  String get unauthorized;

  /// No description provided for @category.
  ///
  /// In pt, this message translates to:
  /// **'Categoria'**
  String get category;

  /// No description provided for @subcategory.
  ///
  /// In pt, this message translates to:
  /// **'Sub categoria'**
  String get subcategory;

  /// No description provided for @report.
  ///
  /// In pt, this message translates to:
  /// **'Relatório'**
  String get report;

  /// No description provided for @reportHasNoDataToDisplay.
  ///
  /// In pt, this message translates to:
  /// **'Relatório SEM DADOS para exibir'**
  String get reportHasNoDataToDisplay;

  /// No description provided for @theReportIsBeingGeneratedAgainSomeReportsTakeLonger.
  ///
  /// In pt, this message translates to:
  /// **'O relatório está sendo gerado novamente.\n\nAlguns relatórios demoram para serem gerados. Por isso, aguarde alguns instantes e consulte os relatórios novamente para verificar se a data da última geração foi alterada'**
  String get theReportIsBeingGeneratedAgainSomeReportsTakeLonger;

  /// No description provided for @lastGenerated.
  ///
  /// In pt, this message translates to:
  /// **'Última geração'**
  String get lastGenerated;

  /// No description provided for @generate.
  ///
  /// In pt, this message translates to:
  /// **'Gerar'**
  String get generate;

  /// No description provided for @sendByEmail.
  ///
  /// In pt, this message translates to:
  /// **'Enviar por e-mail?'**
  String get sendByEmail;

  /// No description provided for @startedBy.
  ///
  /// In pt, this message translates to:
  /// **'Iniciado por'**
  String get startedBy;

  /// No description provided for @thisProcessHasAlreadyBeenReviewed.
  ///
  /// In pt, this message translates to:
  /// **'Esse processo já foi julgado'**
  String get thisProcessHasAlreadyBeenReviewed;

  /// No description provided for @vote.
  ///
  /// In pt, this message translates to:
  /// **'Votar'**
  String get vote;

  /// No description provided for @view.
  ///
  /// In pt, this message translates to:
  /// **'Visualizar'**
  String get view;

  /// No description provided for @viewPath.
  ///
  /// In pt, this message translates to:
  /// **'Visualizar caminho'**
  String get viewPath;

  /// No description provided for @filePath.
  ///
  /// In pt, this message translates to:
  /// **'Caminho do arquivo'**
  String get filePath;

  /// No description provided for @spreadsheetDownloaded.
  ///
  /// In pt, this message translates to:
  /// **'Planilha baixada'**
  String get spreadsheetDownloaded;

  /// No description provided for @downloadSpreadsheet.
  ///
  /// In pt, this message translates to:
  /// **'Baixar planilha'**
  String get downloadSpreadsheet;

  /// No description provided for @downloadPdf.
  ///
  /// In pt, this message translates to:
  /// **'Baixar PDF'**
  String get downloadPdf;

  /// No description provided for @pdfDownloaded.
  ///
  /// In pt, this message translates to:
  /// **'PDF baixado'**
  String get pdfDownloaded;

  /// No description provided for @discountAnalysis.
  ///
  /// In pt, this message translates to:
  /// **'Análise de descontos'**
  String get discountAnalysis;

  /// No description provided for @profitabilityAnalysis.
  ///
  /// In pt, this message translates to:
  /// **'Análise de lucratividade'**
  String get profitabilityAnalysis;

  /// No description provided for @noDiscountsFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum desconto encontrado'**
  String get noDiscountsFound;

  /// No description provided for @noProfitabilityDataFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma lucratividade encontrada'**
  String get noProfitabilityDataFound;

  /// No description provided for @replacement2.
  ///
  /// In pt, this message translates to:
  /// **'Reposição'**
  String get replacement2;

  /// No description provided for @netCost.
  ///
  /// In pt, this message translates to:
  /// **'Cust líq'**
  String get netCost;

  /// No description provided for @operatingExp.
  ///
  /// In pt, this message translates to:
  /// **'Desp op'**
  String get operatingExp;

  /// No description provided for @tax2.
  ///
  /// In pt, this message translates to:
  /// **'Imposto'**
  String get tax2;

  /// No description provided for @revenue.
  ///
  /// In pt, this message translates to:
  /// **'Faturamento'**
  String get revenue;

  /// No description provided for @profit.
  ///
  /// In pt, this message translates to:
  /// **'Lucro'**
  String get profit;

  /// No description provided for @margin.
  ///
  /// In pt, this message translates to:
  /// **'Margem'**
  String get margin;

  /// No description provided for @min2.
  ///
  /// In pt, this message translates to:
  /// **'Mín'**
  String get min2;

  /// No description provided for @unitDiff.
  ///
  /// In pt, this message translates to:
  /// **'Dif unit'**
  String get unitDiff;

  /// No description provided for @totalDiff.
  ///
  /// In pt, this message translates to:
  /// **'Dif total'**
  String get totalDiff;

  /// No description provided for @gross.
  ///
  /// In pt, this message translates to:
  /// **'Bruto'**
  String get gross;

  /// No description provided for @net2.
  ///
  /// In pt, this message translates to:
  /// **'Líquido'**
  String get net2;

  /// No description provided for @max.
  ///
  /// In pt, this message translates to:
  /// **'Máx'**
  String get max;

  /// No description provided for @difference.
  ///
  /// In pt, this message translates to:
  /// **'Diferença'**
  String get difference;

  /// No description provided for @awaitingAuthorization.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando autorização'**
  String get awaitingAuthorization;

  /// No description provided for @unauthorized2.
  ///
  /// In pt, this message translates to:
  /// **'Não autorizados'**
  String get unauthorized2;

  /// No description provided for @stockToReplace.
  ///
  /// In pt, this message translates to:
  /// **'Estoque a ser substituído'**
  String get stockToReplace;

  /// No description provided for @selectTheStock.
  ///
  /// In pt, this message translates to:
  /// **'Você precisa selecionar o estoque!'**
  String get selectTheStock;

  /// No description provided for @attention3.
  ///
  /// In pt, this message translates to:
  /// **'Atenção!!!'**
  String get attention3;

  /// No description provided for @confirmingWillUpdateTheProductSStockToTheQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Ao confirmar, o estoque do produto será atualizado para a quantidade que você informou!\n\nDeseja continuar?'**
  String get confirmingWillUpdateTheProductSStockToTheQuantity;

  /// No description provided for @lastAcceptedQty.
  ///
  /// In pt, this message translates to:
  /// **'Última qtd ASSUMIDA'**
  String get lastAcceptedQty;

  /// No description provided for @noProcessesFoundWithStatus.
  ///
  /// In pt, this message translates to:
  /// **'Não foram encontrados processos com o status '**
  String get noProcessesFoundWithStatus;

  /// No description provided for @processStartedBy.
  ///
  /// In pt, this message translates to:
  /// **'Processo iniciado por'**
  String get processStartedBy;

  /// No description provided for @authorizers.
  ///
  /// In pt, this message translates to:
  /// **'Autorizadores'**
  String get authorizers;

  /// No description provided for @reviews.
  ///
  /// In pt, this message translates to:
  /// **'Julgamentos'**
  String get reviews;

  /// No description provided for @linkToThisProduct.
  ///
  /// In pt, this message translates to:
  /// **'Deseja associar a esse produto?'**
  String get linkToThisProduct;

  /// No description provided for @countedQty2.
  ///
  /// In pt, this message translates to:
  /// **'Qtd contagem'**
  String get countedQty2;

  /// No description provided for @xmlDifferences.
  ///
  /// In pt, this message translates to:
  /// **'Diferenças de XML'**
  String get xmlDifferences;

  /// No description provided for @notReviewed.
  ///
  /// In pt, this message translates to:
  /// **'Não julgados'**
  String get notReviewed;

  /// No description provided for @reviewed.
  ///
  /// In pt, this message translates to:
  /// **'Julgados'**
  String get reviewed;

  /// No description provided for @notRegistered.
  ///
  /// In pt, this message translates to:
  /// **'Sem cadastro'**
  String get notRegistered;

  /// No description provided for @noReviewedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Não há produtos julgados'**
  String get noReviewedProducts;

  /// No description provided for @allProductsHaveAlreadyBeenReviewed.
  ///
  /// In pt, this message translates to:
  /// **'Todos produtos já foram julgados'**
  String get allProductsHaveAlreadyBeenReviewed;

  /// No description provided for @invoiceQty.
  ///
  /// In pt, this message translates to:
  /// **'Qtd NF'**
  String get invoiceQty;

  /// No description provided for @orderQty.
  ///
  /// In pt, this message translates to:
  /// **'Qtd ped'**
  String get orderQty;

  /// No description provided for @otherOrderQty.
  ///
  /// In pt, this message translates to:
  /// **'Qtd outr ped'**
  String get otherOrderQty;

  /// No description provided for @qtyDiff.
  ///
  /// In pt, this message translates to:
  /// **'Dif qtd'**
  String get qtyDiff;

  /// No description provided for @invoiceNetAmount.
  ///
  /// In pt, this message translates to:
  /// **'Vl líq NF'**
  String get invoiceNetAmount;

  /// No description provided for @orderNetAmount.
  ///
  /// In pt, this message translates to:
  /// **'Vl líq ped'**
  String get orderNetAmount;

  /// No description provided for @netAmountDiff.
  ///
  /// In pt, this message translates to:
  /// **'Dif vl líq'**
  String get netAmountDiff;

  /// No description provided for @totalNetAmountDiff.
  ///
  /// In pt, this message translates to:
  /// **'Tot dif vl líq'**
  String get totalNetAmountDiff;

  /// No description provided for @returnAllQuantitiesOfTheSelectedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Deseja devolver todas as quantidades dos produtos selecionados?'**
  String get returnAllQuantitiesOfTheSelectedProducts;

  /// No description provided for @returnOnlyTheExcessQuantityOfTheSelectedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Deseja devolver somente a quantidade excedente dos produtos selecionados?'**
  String get returnOnlyTheExcessQuantityOfTheSelectedProducts;

  /// No description provided for @acceptTheDiscrepanciesForTheSelectedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Deseja aceitar as divergências dos produtos selecionados?'**
  String get acceptTheDiscrepanciesForTheSelectedProducts;

  /// No description provided for @voidTheReviewsOfTheSelectedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Deseja anular os julgamentos dos produtos selecionados?'**
  String get voidTheReviewsOfTheSelectedProducts;

  /// No description provided for @voidReviews.
  ///
  /// In pt, this message translates to:
  /// **'Anular julgamentos'**
  String get voidReviews;

  /// No description provided for @accept.
  ///
  /// In pt, this message translates to:
  /// **'Aceitar'**
  String get accept;

  /// No description provided for @returnExcess.
  ///
  /// In pt, this message translates to:
  /// **'Devolver excesso'**
  String get returnExcess;

  /// No description provided for @unableToFindTheDocument.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível encontrar o documento'**
  String get unableToFindTheDocument;

  /// No description provided for @sourceCompany2.
  ///
  /// In pt, this message translates to:
  /// **'Empresa origem'**
  String get sourceCompany2;

  /// No description provided for @documentType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de documento'**
  String get documentType;

  /// No description provided for @nfeKey.
  ///
  /// In pt, this message translates to:
  /// **'Chave NFe'**
  String get nfeKey;

  /// No description provided for @nfeSeries.
  ///
  /// In pt, this message translates to:
  /// **'Série NFe'**
  String get nfeSeries;

  /// No description provided for @verificationCompleted.
  ///
  /// In pt, this message translates to:
  /// **'Conferência concluída!'**
  String get verificationCompleted;

  /// No description provided for @leavingWillDiscardTheCountedQuantitiesLeaveAnyway.
  ///
  /// In pt, this message translates to:
  /// **'Ao sair, as quantidades contadas serão perdidas. Deseja sair mesmo assim?'**
  String get leavingWillDiscardTheCountedQuantitiesLeaveAnyway;

  /// No description provided for @noProductsVerifiedYet.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto conferido até o momento'**
  String get noProductsVerifiedYet;

  /// No description provided for @selectTheProductToConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Selecione o produto que deseja confirmar'**
  String get selectTheProductToConfirm;

  /// No description provided for @pending.
  ///
  /// In pt, this message translates to:
  /// **'Pendentes'**
  String get pending;

  /// No description provided for @verified.
  ///
  /// In pt, this message translates to:
  /// **'Conferidos'**
  String get verified;

  /// No description provided for @documents.
  ///
  /// In pt, this message translates to:
  /// **'Documentos'**
  String get documents;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settings;

  /// No description provided for @reloadSettings.
  ///
  /// In pt, this message translates to:
  /// **'Recarregar configurações'**
  String get reloadSettings;

  /// No description provided for @noDocumentsAreUndergoingProductVerification.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum documento está no processo de conferência de produtos'**
  String get noDocumentsAreUndergoingProductVerification;

  /// No description provided for @step.
  ///
  /// In pt, this message translates to:
  /// **'Etapa'**
  String get step;

  /// No description provided for @productSearchType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de pesquisa de produtos'**
  String get productSearchType;

  /// No description provided for @autoScan.
  ///
  /// In pt, this message translates to:
  /// **'Auto scan'**
  String get autoScan;

  /// No description provided for @goodsReceipts.
  ///
  /// In pt, this message translates to:
  /// **'Recebimentos'**
  String get goodsReceipts;

  /// No description provided for @numberIssuerStatusNote.
  ///
  /// In pt, this message translates to:
  /// **'Número|Emitente|Status|Observação'**
  String get numberIssuerStatusNote;

  /// No description provided for @filter.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar'**
  String get filter;

  /// No description provided for @thisProductIsNotPendingVerification.
  ///
  /// In pt, this message translates to:
  /// **'Esse produto não está pendente para conferência'**
  String get thisProductIsNotPendingVerification;

  /// No description provided for @addNote.
  ///
  /// In pt, this message translates to:
  /// **'Inserir obs'**
  String get addNote;

  /// No description provided for @editNote.
  ///
  /// In pt, this message translates to:
  /// **'Alterar obs'**
  String get editNote;

  /// No description provided for @issuer.
  ///
  /// In pt, this message translates to:
  /// **'Emitente'**
  String get issuer;

  /// No description provided for @group.
  ///
  /// In pt, this message translates to:
  /// **'Grupo'**
  String get group;

  /// No description provided for @newNote.
  ///
  /// In pt, this message translates to:
  /// **'Nova observação'**
  String get newNote;

  /// No description provided for @pendingNote.
  ///
  /// In pt, this message translates to:
  /// **'Observação pendente'**
  String get pendingNote;

  /// No description provided for @alreadyReleased.
  ///
  /// In pt, this message translates to:
  /// **'Já liberado'**
  String get alreadyReleased;

  /// No description provided for @release.
  ///
  /// In pt, this message translates to:
  /// **'Liberar'**
  String get release;

  /// No description provided for @thisDocumentIsUndergoingAuthorizationAndCannotBeReleased.
  ///
  /// In pt, this message translates to:
  /// **'Esse documento está em processo de autorização e por isso não pode ser liberado'**
  String get thisDocumentIsUndergoingAuthorizationAndCannotBeReleased;

  /// No description provided for @release2.
  ///
  /// In pt, this message translates to:
  /// **'Liberar?'**
  String get release2;

  /// No description provided for @areYouSureYouWantToReleaseThisDocument.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja liberar esse documento?'**
  String get areYouSureYouWantToReleaseThisDocument;

  /// No description provided for @verifyProducts.
  ///
  /// In pt, this message translates to:
  /// **'Conferir produtos'**
  String get verifyProducts;

  /// No description provided for @defaultNote.
  ///
  /// In pt, this message translates to:
  /// **'Observação padrão'**
  String get defaultNote;

  /// No description provided for @confirmNote.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar obs'**
  String get confirmNote;

  /// No description provided for @newExpirationDate.
  ///
  /// In pt, this message translates to:
  /// **'Nova validade'**
  String get newExpirationDate;

  /// No description provided for @none2.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma'**
  String get none2;

  /// No description provided for @subtract.
  ///
  /// In pt, this message translates to:
  /// **'Subtrair'**
  String get subtract;

  /// No description provided for @add3.
  ///
  /// In pt, this message translates to:
  /// **'Somar'**
  String get add3;

  /// No description provided for @areYouSureYouWantToVoidTheCount.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja anular a contagem?'**
  String get areYouSureYouWantToVoidTheCount;

  /// No description provided for @updateRequired.
  ///
  /// In pt, this message translates to:
  /// **'Atualização necesssária!'**
  String get updateRequired;

  /// No description provided for @askBsSupportToUpdateTheSystemToUseThis.
  ///
  /// In pt, this message translates to:
  /// **'Para utilizar essa funcionalidade, peça para o suporte do BS atualizar o sistema'**
  String get askBsSupportToUpdateTheSystemToUseThis;

  /// No description provided for @weighedProducts.
  ///
  /// In pt, this message translates to:
  /// **'Pesáveis'**
  String get weighedProducts;

  /// No description provided for @noEan.
  ///
  /// In pt, this message translates to:
  /// **'Sem EAN'**
  String get noEan;

  /// No description provided for @alreadyCounted.
  ///
  /// In pt, this message translates to:
  /// **'Já contados'**
  String get alreadyCounted;

  /// No description provided for @noExpirationDate.
  ///
  /// In pt, this message translates to:
  /// **'Sem validade'**
  String get noExpirationDate;

  /// No description provided for @countedQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade contada'**
  String get countedQuantity;

  /// No description provided for @theNewQuantityCannotBeLessThanZero.
  ///
  /// In pt, this message translates to:
  /// **'A nova quantidade não pode ser menor que zero'**
  String get theNewQuantityCannotBeLessThanZero;

  /// No description provided for @personalDetails.
  ///
  /// In pt, this message translates to:
  /// **'Dados pessoais'**
  String get personalDetails;

  /// No description provided for @saveDetails.
  ///
  /// In pt, this message translates to:
  /// **'Salvar dados?'**
  String get saveDetails;

  /// No description provided for @thereAreStillUnregisteredProductsTheyNeedToBeLinked.
  ///
  /// In pt, this message translates to:
  /// **'Ainda existem produtos sem cadastros. Eles precisam ser vinculados'**
  String get thereAreStillUnregisteredProductsTheyNeedToBeLinked;

  /// No description provided for @reviewAllProductsBeforeVoting.
  ///
  /// In pt, this message translates to:
  /// **'Julgue todos os produtos antes de votar'**
  String get reviewAllProductsBeforeVoting;

  /// No description provided for @cpfCnpj2.
  ///
  /// In pt, this message translates to:
  /// **'CPF/CNPJ '**
  String get cpfCnpj2;

  /// No description provided for @name2.
  ///
  /// In pt, this message translates to:
  /// **'Nome '**
  String get name2;

  /// No description provided for @shortName.
  ///
  /// In pt, this message translates to:
  /// **'Nome reduzido '**
  String get shortName;

  /// No description provided for @birthDate.
  ///
  /// In pt, this message translates to:
  /// **'Nascimento '**
  String get birthDate;

  /// No description provided for @password2.
  ///
  /// In pt, this message translates to:
  /// **'Senha '**
  String get password2;

  /// No description provided for @sex.
  ///
  /// In pt, this message translates to:
  /// **'Sexo '**
  String get sex;

  /// No description provided for @unableToLoadTheSalesOrderData.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar os dados do pedido de vendas'**
  String get unableToLoadTheSalesOrderData;

  /// No description provided for @processNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Processo não encontrado'**
  String get processNotFound;

  /// No description provided for @filterCompany.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar empresa'**
  String get filterCompany;

  /// No description provided for @filterUsageType.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar tipo de uso'**
  String get filterUsageType;

  /// No description provided for @thisPhoneNumberHasAlreadyBeenAdded.
  ///
  /// In pt, this message translates to:
  /// **'Esse telefone já foi adicionado'**
  String get thisPhoneNumberHasAlreadyBeenAdded;

  /// No description provided for @addPhoneNumber.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar telefone'**
  String get addPhoneNumber;

  /// No description provided for @update.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar'**
  String get update;

  /// No description provided for @monthYear.
  ///
  /// In pt, this message translates to:
  /// **'Mês/ano'**
  String get monthYear;

  /// No description provided for @noUsageFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum uso encontrado'**
  String get noUsageFound;

  /// No description provided for @noResultsFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum resultado encontrado'**
  String get noResultsFound;

  /// No description provided for @requestsByType.
  ///
  /// In pt, this message translates to:
  /// **'Requisições por tipo'**
  String get requestsByType;

  /// No description provided for @requestsByUser.
  ///
  /// In pt, this message translates to:
  /// **'Requisições por usuário'**
  String get requestsByUser;

  /// No description provided for @manageModules.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciar módulos'**
  String get manageModules;

  /// No description provided for @usage.
  ///
  /// In pt, this message translates to:
  /// **'Uso'**
  String get usage;

  /// No description provided for @phone.
  ///
  /// In pt, this message translates to:
  /// **'Telefone'**
  String get phone;

  /// No description provided for @enteredPhoneNumbers.
  ///
  /// In pt, this message translates to:
  /// **'Telefones informados'**
  String get enteredPhoneNumbers;

  /// No description provided for @removePhoneNumber.
  ///
  /// In pt, this message translates to:
  /// **'Remover telefone?'**
  String get removePhoneNumber;

  /// No description provided for @noCompaniesFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma empresa encontrada.'**
  String get noCompaniesFound;

  /// No description provided for @noPermission.
  ///
  /// In pt, this message translates to:
  /// **'Sem permissão'**
  String get noPermission;

  /// No description provided for @onlyAdministratorsCanMakeThisChange.
  ///
  /// In pt, this message translates to:
  /// **'Somente administradores podem fazer essa alteração'**
  String get onlyAdministratorsCanMakeThisChange;

  /// No description provided for @sex2.
  ///
  /// In pt, this message translates to:
  /// **'Sexo'**
  String get sex2;

  /// No description provided for @shortName2.
  ///
  /// In pt, this message translates to:
  /// **'Nome reduzido'**
  String get shortName2;

  /// No description provided for @confirmPassword.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar senha'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In pt, this message translates to:
  /// **'As senhas não conferem'**
  String get passwordsDoNotMatch;

  /// No description provided for @stateTaxRegistration.
  ///
  /// In pt, this message translates to:
  /// **'Inscrição estadual'**
  String get stateTaxRegistration;

  /// No description provided for @birthDate2.
  ///
  /// In pt, this message translates to:
  /// **'Nascimento'**
  String get birthDate2;

  /// No description provided for @companyRegisteredSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Empresa cadastrada com sucesso'**
  String get companyRegisteredSuccessfully;

  /// No description provided for @createCompany.
  ///
  /// In pt, this message translates to:
  /// **'Criar empresa'**
  String get createCompany;

  /// No description provided for @bsUsername.
  ///
  /// In pt, this message translates to:
  /// **'Nome do usuário no BS'**
  String get bsUsername;

  /// No description provided for @remoteHttp.
  ///
  /// In pt, this message translates to:
  /// **'HTTP remota'**
  String get remoteHttp;

  /// No description provided for @remoteHttps.
  ///
  /// In pt, this message translates to:
  /// **'HTTPS remota'**
  String get remoteHttps;

  /// No description provided for @enteredEmails.
  ///
  /// In pt, this message translates to:
  /// **'E-mails informados'**
  String get enteredEmails;

  /// No description provided for @removeEmail.
  ///
  /// In pt, this message translates to:
  /// **'Remover e-mail?'**
  String get removeEmail;

  /// No description provided for @localHttp.
  ///
  /// In pt, this message translates to:
  /// **'HTTP local'**
  String get localHttp;

  /// No description provided for @thisEmailHasAlreadyBeenAdded.
  ///
  /// In pt, this message translates to:
  /// **'Esse e-mail já foi adicionado'**
  String get thisEmailHasAlreadyBeenAdded;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In pt, this message translates to:
  /// **'Inserir e-mail'**
  String get enterEmail;

  /// No description provided for @localHttps.
  ///
  /// In pt, this message translates to:
  /// **'HTTPS local'**
  String get localHttps;

  /// No description provided for @companyName.
  ///
  /// In pt, this message translates to:
  /// **'Nome da empresa'**
  String get companyName;

  /// No description provided for @customerSavedSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Cliente cadastrado/atualizado com sucesso'**
  String get customerSavedSuccessfully;

  /// No description provided for @details2.
  ///
  /// In pt, this message translates to:
  /// **'Dados'**
  String get details2;

  /// No description provided for @unlinkedAgreements.
  ///
  /// In pt, this message translates to:
  /// **'Convênios sem vínculo'**
  String get unlinkedAgreements;

  /// No description provided for @cnpj2.
  ///
  /// In pt, this message translates to:
  /// **'CNPJ '**
  String get cnpj2;

  /// No description provided for @address2.
  ///
  /// In pt, this message translates to:
  /// **'Endereço '**
  String get address2;

  /// No description provided for @limitR.
  ///
  /// In pt, this message translates to:
  /// **'Limite R\$'**
  String get limitR;

  /// No description provided for @link2.
  ///
  /// In pt, this message translates to:
  /// **'Vincular'**
  String get link2;

  /// No description provided for @linkedAgreements.
  ///
  /// In pt, this message translates to:
  /// **'Convênios vinculados'**
  String get linkedAgreements;

  /// No description provided for @code2.
  ///
  /// In pt, this message translates to:
  /// **'Código '**
  String get code2;

  /// No description provided for @limit.
  ///
  /// In pt, this message translates to:
  /// **'Limite '**
  String get limit;

  /// No description provided for @removeAgreement.
  ///
  /// In pt, this message translates to:
  /// **'Remover convênio'**
  String get removeAgreement;

  /// No description provided for @areYouSureYouWantToRemoveThisAgreement.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja remover esse convênio?'**
  String get areYouSureYouWantToRemoveThisAgreement;

  /// No description provided for @remoteHttp2.
  ///
  /// In pt, this message translates to:
  /// **'HTTP remoto'**
  String get remoteHttp2;

  /// No description provided for @remoteHttps2.
  ///
  /// In pt, this message translates to:
  /// **'HTTPS remoto'**
  String get remoteHttps2;

  /// No description provided for @enabled.
  ///
  /// In pt, this message translates to:
  /// **'Habilitado'**
  String get enabled;

  /// No description provided for @inherit.
  ///
  /// In pt, this message translates to:
  /// **'Herdar'**
  String get inherit;

  /// No description provided for @disabled.
  ///
  /// In pt, this message translates to:
  /// **'Desabilitado'**
  String get disabled;

  /// No description provided for @permissionsChangedSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Permissões alteradas com sucesso'**
  String get permissionsChangedSuccessfully;

  /// No description provided for @globalPermissions.
  ///
  /// In pt, this message translates to:
  /// **'Permissões globais'**
  String get globalPermissions;

  /// No description provided for @specificPermissions.
  ///
  /// In pt, this message translates to:
  /// **'Permissões específicas'**
  String get specificPermissions;

  /// No description provided for @companyNotFound2.
  ///
  /// In pt, this message translates to:
  /// **'Empresa não encontrada.'**
  String get companyNotFound2;

  /// No description provided for @requestTimedOutPleaseTryAgain.
  ///
  /// In pt, this message translates to:
  /// **'Tempo limite atingido. Por favor, tente novamente.'**
  String get requestTimedOutPleaseTryAgain;

  /// No description provided for @connectionErrorCheckYourInternetConnection.
  ///
  /// In pt, this message translates to:
  /// **'Erro de conexão. Verifique a sua internet.'**
  String get connectionErrorCheckYourInternetConnection;

  /// No description provided for @invalidLoginCredentialsCheckYourEmailAndPassword.
  ///
  /// In pt, this message translates to:
  /// **'Credenciais de login inválidas. Por favor, verifique seu e-mail e senha.'**
  String get invalidLoginCredentialsCheckYourEmailAndPassword;

  /// No description provided for @thePasswordMustContainAtLeast6Characters.
  ///
  /// In pt, this message translates to:
  /// **'A senha deve ter pelo menos 6 caracteres.'**
  String get thePasswordMustContainAtLeast6Characters;

  /// No description provided for @thisEmailIsAlreadyRegistered.
  ///
  /// In pt, this message translates to:
  /// **'Este e-mail já está cadastrado.'**
  String get thisEmailIsAlreadyRegistered;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In pt, this message translates to:
  /// **'Formato de e-mail inválido.'**
  String get invalidEmailFormat;

  /// No description provided for @thisActionIsTemporarilyBlockedTryAgainLater.
  ///
  /// In pt, this message translates to:
  /// **'Essa ação está bloqueada temporariamente. Tente novamente daqui a pouco.'**
  String get thisActionIsTemporarilyBlockedTryAgainLater;

  /// No description provided for @methodNotFoundTellTechnicalSupportThatTheApiIs.
  ///
  /// In pt, this message translates to:
  /// **'O método não foi encontrado. Informe o suporte técnico que a API não está funcionando ou deve ser atualizada'**
  String get methodNotFoundTellTechnicalSupportThatTheApiIs;

  /// No description provided for @login.
  ///
  /// In pt, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @postalCode2.
  ///
  /// In pt, this message translates to:
  /// **'CEP '**
  String get postalCode2;

  /// No description provided for @deleteAddress.
  ///
  /// In pt, this message translates to:
  /// **'Excluir endereço?'**
  String get deleteAddress;

  /// No description provided for @addressComplement.
  ///
  /// In pt, this message translates to:
  /// **'Complemento '**
  String get addressComplement;

  /// No description provided for @reference2.
  ///
  /// In pt, this message translates to:
  /// **'Referência '**
  String get reference2;

  /// No description provided for @thisAddressHasAlreadyBeenAdded.
  ///
  /// In pt, this message translates to:
  /// **'Esse endereço já foi inserido'**
  String get thisAddressHasAlreadyBeenAdded;

  /// No description provided for @labelLayouts.
  ///
  /// In pt, this message translates to:
  /// **'Leiautes de etiquetas'**
  String get labelLayouts;

  /// No description provided for @reportedIssues.
  ///
  /// In pt, this message translates to:
  /// **'Problemas reportados'**
  String get reportedIssues;

  /// No description provided for @noLabelLayoutsFound.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum leiaute de etiqueta encontrado'**
  String get noLabelLayoutsFound;

  /// No description provided for @printer.
  ///
  /// In pt, this message translates to:
  /// **'Impressora'**
  String get printer;

  /// No description provided for @noReportedIssues.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum problema reportado'**
  String get noReportedIssues;

  /// No description provided for @unableToLoadTheImage.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar a imagem'**
  String get unableToLoadTheImage;

  /// No description provided for @labelPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Foto da etiqueta'**
  String get labelPhoto;

  /// No description provided for @canvasImage.
  ///
  /// In pt, this message translates to:
  /// **'Imagem do canvas'**
  String get canvasImage;

  /// No description provided for @issueReport.
  ///
  /// In pt, this message translates to:
  /// **'Relato'**
  String get issueReport;

  /// No description provided for @layout.
  ///
  /// In pt, this message translates to:
  /// **'Leiaute'**
  String get layout;

  /// No description provided for @environment.
  ///
  /// In pt, this message translates to:
  /// **'Ambiente'**
  String get environment;

  /// No description provided for @failedToCaptureTheCanvas.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao capturar o canvas'**
  String get failedToCaptureTheCanvas;

  /// No description provided for @copyDiagnostics.
  ///
  /// In pt, this message translates to:
  /// **'Copiar diagnóstico'**
  String get copyDiagnostics;

  /// No description provided for @close.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get close;

  /// No description provided for @reportAPrintingIssue.
  ///
  /// In pt, this message translates to:
  /// **'Relatar problema de impressão'**
  String get reportAPrintingIssue;

  /// No description provided for @checkTheSavedLayoutBeforeTakingAPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Confira o leiaute salvo antes de fotografar.'**
  String get checkTheSavedLayoutBeforeTakingAPhoto;

  /// No description provided for @sendingReport.
  ///
  /// In pt, this message translates to:
  /// **'Enviando relatório...'**
  String get sendingReport;

  /// No description provided for @reportCanceled.
  ///
  /// In pt, this message translates to:
  /// **'Relatório cancelado.'**
  String get reportCanceled;

  /// No description provided for @issueDetails.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes do problema'**
  String get issueDetails;

  /// No description provided for @describeTheExpectedResultAndTheIssueEncountered.
  ///
  /// In pt, this message translates to:
  /// **'Explique o resultado esperado e o problema encontrado'**
  String get describeTheExpectedResultAndTheIssueEncountered;

  /// No description provided for @iAuthorizeSendingBothImagesTheSavedLayoutMyName.
  ///
  /// In pt, this message translates to:
  /// **'Autorizo o envio das duas imagens, leiaute salvo, meu nome, empresa e dados seguros do app/dispositivo ao suporte técnico'**
  String get iAuthorizeSendingBothImagesTheSavedLayoutMyName;

  /// No description provided for @sendReport.
  ///
  /// In pt, this message translates to:
  /// **'Enviar relatório'**
  String get sendReport;

  /// No description provided for @retakeCaptures.
  ///
  /// In pt, this message translates to:
  /// **'Refazer capturas'**
  String get retakeCaptures;

  /// No description provided for @reportSent.
  ///
  /// In pt, this message translates to:
  /// **'Relatório enviado'**
  String get reportSent;

  /// No description provided for @unableToCompleteTheReport.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível concluir o relatório.'**
  String get unableToCompleteTheReport;

  /// No description provided for @theEntireLabelIsVisible.
  ///
  /// In pt, this message translates to:
  /// **'A etiqueta inteira está visível'**
  String get theEntireLabelIsVisible;

  /// No description provided for @thereIsARulerAboveOrBelowTheLabel.
  ///
  /// In pt, this message translates to:
  /// **'Há uma régua acima ou abaixo da etiqueta'**
  String get thereIsARulerAboveOrBelowTheLabel;

  /// No description provided for @thePhotoIsInFocusAndHasNoGlare.
  ///
  /// In pt, this message translates to:
  /// **'A foto está focada e sem reflexo'**
  String get thePhotoIsInFocusAndHasNoGlare;

  /// No description provided for @takeAnotherPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Tirar outra foto'**
  String get takeAnotherPhoto;

  /// No description provided for @useThisPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Usar esta foto'**
  String get useThisPhoto;

  /// No description provided for @takePhoto.
  ///
  /// In pt, this message translates to:
  /// **'Fotografar'**
  String get takePhoto;

  /// No description provided for @addFieldToLayout.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar campo ao leiaute'**
  String get addFieldToLayout;

  /// No description provided for @layoutSavedSuccessfully.
  ///
  /// In pt, this message translates to:
  /// **'Leiaute salvo com sucesso'**
  String get layoutSavedSuccessfully;

  /// No description provided for @allChangesWillBeLostCloseThisScreen.
  ///
  /// In pt, this message translates to:
  /// **'Todas alterações realizadas serão perdidas. Deseja realmente fechar a tela?'**
  String get allChangesWillBeLostCloseThisScreen;

  /// No description provided for @discardChanges.
  ///
  /// In pt, this message translates to:
  /// **'Descartar alterações'**
  String get discardChanges;

  /// No description provided for @allChangesWillBeLostRefreshTheData.
  ///
  /// In pt, this message translates to:
  /// **'Todas as alterações realizadas serão perdidas. Deseja realmente atualizar os dados?'**
  String get allChangesWillBeLostRefreshTheData;

  /// No description provided for @layoutDetails.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes do leiaute'**
  String get layoutDetails;

  /// No description provided for @selectThePrinter.
  ///
  /// In pt, this message translates to:
  /// **'Selecione a impressora'**
  String get selectThePrinter;

  /// No description provided for @addField.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar campo'**
  String get addField;

  /// No description provided for @printerFormAndLabel.
  ///
  /// In pt, this message translates to:
  /// **'Impressora, formulário e etiqueta'**
  String get printerFormAndLabel;

  /// No description provided for @noFieldsConfigured.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum campo configurado'**
  String get noFieldsConfigured;

  /// No description provided for @hideFromPreview.
  ///
  /// In pt, this message translates to:
  /// **'Ocultar do preview'**
  String get hideFromPreview;

  /// No description provided for @showInPreview.
  ///
  /// In pt, this message translates to:
  /// **'Exibir no preview'**
  String get showInPreview;

  /// No description provided for @reportIssue.
  ///
  /// In pt, this message translates to:
  /// **'Relatar problema'**
  String get reportIssue;

  /// No description provided for @saveTheLayout.
  ///
  /// In pt, this message translates to:
  /// **'Salve o leiaute'**
  String get saveTheLayout;

  /// No description provided for @saveOrDiscardChangesBeforeReportingAnIssue.
  ///
  /// In pt, this message translates to:
  /// **'Salve ou descarte as alterações antes de relatar um problema.'**
  String get saveOrDiscardChangesBeforeReportingAnIssue;

  /// No description provided for @saveChanges.
  ///
  /// In pt, this message translates to:
  /// **'Salvar alterações'**
  String get saveChanges;

  /// No description provided for @saveTheseChanges.
  ///
  /// In pt, this message translates to:
  /// **'Deseja realmente salvar as alterações?'**
  String get saveTheseChanges;

  /// No description provided for @logo.
  ///
  /// In pt, this message translates to:
  /// **'Logotipo'**
  String get logo;

  /// No description provided for @field.
  ///
  /// In pt, this message translates to:
  /// **'Campo'**
  String get field;

  /// No description provided for @preview.
  ///
  /// In pt, this message translates to:
  /// **'Pré-visualização '**
  String get preview;

  /// No description provided for @approximate.
  ///
  /// In pt, this message translates to:
  /// **'(APROXIMADA)'**
  String get approximate;

  /// No description provided for @addFieldsToDetermineThePreviewHeight.
  ///
  /// In pt, this message translates to:
  /// **'Adicione campos para determinar a altura da pré-visualização'**
  String get addFieldsToDetermineThePreviewHeight;

  /// No description provided for @enterAValidWidthAndHeightToPreviewTheLabel.
  ///
  /// In pt, this message translates to:
  /// **'Informe uma largura e altura válidas para visualizar a etiqueta'**
  String get enterAValidWidthAndHeightToPreviewTheLabel;

  /// No description provided for @printerParameters.
  ///
  /// In pt, this message translates to:
  /// **'Parâmetros da impressora'**
  String get printerParameters;

  /// No description provided for @temperature.
  ///
  /// In pt, this message translates to:
  /// **'Temperatura'**
  String get temperature;

  /// No description provided for @speed.
  ///
  /// In pt, this message translates to:
  /// **'Velocidade'**
  String get speed;

  /// No description provided for @packetInterval.
  ///
  /// In pt, this message translates to:
  /// **'Intervalo do pacote'**
  String get packetInterval;

  /// No description provided for @dots.
  ///
  /// In pt, this message translates to:
  /// **'pontos'**
  String get dots;

  /// No description provided for @width.
  ///
  /// In pt, this message translates to:
  /// **'Largura'**
  String get width;

  /// No description provided for @height.
  ///
  /// In pt, this message translates to:
  /// **'Altura'**
  String get height;

  /// No description provided for @rightMargin.
  ///
  /// In pt, this message translates to:
  /// **'Mg direita'**
  String get rightMargin;

  /// No description provided for @bottomMargin.
  ///
  /// In pt, this message translates to:
  /// **'Mg inferior'**
  String get bottomMargin;

  /// No description provided for @labelDirection.
  ///
  /// In pt, this message translates to:
  /// **'Direção da etiqueta'**
  String get labelDirection;

  /// No description provided for @considerProductPackaging.
  ///
  /// In pt, this message translates to:
  /// **'Considerar embalagem do produto'**
  String get considerProductPackaging;

  /// No description provided for @enterPrintQuantityPerProduct.
  ///
  /// In pt, this message translates to:
  /// **'Informar quantidade de impressão por produto'**
  String get enterPrintQuantityPerProduct;

  /// No description provided for @printOneLabelForEachUnitSold.
  ///
  /// In pt, this message translates to:
  /// **'Imprimir uma etiqueta para cada unidade vendida'**
  String get printOneLabelForEachUnitSold;

  /// No description provided for @onlyProductsSentToInventoryCountingThatAllowACounted.
  ///
  /// In pt, this message translates to:
  /// **'Somente produtos enviados para balanço e que permitem quantidade no balanço'**
  String get onlyProductsSentToInventoryCountingThatAllowACounted;

  /// No description provided for @top.
  ///
  /// In pt, this message translates to:
  /// **'Superior'**
  String get top;

  /// No description provided for @left.
  ///
  /// In pt, this message translates to:
  /// **'Esquerda'**
  String get left;

  /// No description provided for @bottom.
  ///
  /// In pt, this message translates to:
  /// **'Inferior'**
  String get bottom;

  /// No description provided for @right.
  ///
  /// In pt, this message translates to:
  /// **'Direita'**
  String get right;

  /// No description provided for @layoutName.
  ///
  /// In pt, this message translates to:
  /// **'Nome do leiaute'**
  String get layoutName;

  /// No description provided for @fieldsIncompatibleWithTheNewTypeWillBeRemoved.
  ///
  /// In pt, this message translates to:
  /// **'Os campos incompatíveis com o novo tipo serão removidos.'**
  String get fieldsIncompatibleWithTheNewTypeWillBeRemoved;

  /// No description provided for @addressType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de endereço'**
  String get addressType;

  /// No description provided for @main.
  ///
  /// In pt, this message translates to:
  /// **'Principal'**
  String get main;

  /// No description provided for @billing.
  ///
  /// In pt, this message translates to:
  /// **'Cobrança'**
  String get billing;

  /// No description provided for @delivery.
  ///
  /// In pt, this message translates to:
  /// **'Entrega'**
  String get delivery;

  /// No description provided for @notApplicable.
  ///
  /// In pt, this message translates to:
  /// **'Não se aplica'**
  String get notApplicable;

  /// No description provided for @formType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de formulário'**
  String get formType;

  /// No description provided for @height2.
  ///
  /// In pt, this message translates to:
  /// **'Altura *'**
  String get height2;

  /// No description provided for @topMargin.
  ///
  /// In pt, this message translates to:
  /// **'Mg superior'**
  String get topMargin;

  /// No description provided for @leftMargin.
  ///
  /// In pt, this message translates to:
  /// **'Mg esquerda'**
  String get leftMargin;

  /// No description provided for @columns.
  ///
  /// In pt, this message translates to:
  /// **'Colunas'**
  String get columns;

  /// No description provided for @applyFormSizeSettings.
  ///
  /// In pt, this message translates to:
  /// **'Aplicar configuração do tamanho do formulário'**
  String get applyFormSizeSettings;

  /// No description provided for @content.
  ///
  /// In pt, this message translates to:
  /// **'Conteúdo'**
  String get content;

  /// No description provided for @prefix.
  ///
  /// In pt, this message translates to:
  /// **'Prefixo'**
  String get prefix;

  /// No description provided for @xAxis.
  ///
  /// In pt, this message translates to:
  /// **'Eixo X'**
  String get xAxis;

  /// No description provided for @yAxis.
  ///
  /// In pt, this message translates to:
  /// **'Eixo Y'**
  String get yAxis;

  /// No description provided for @size.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho'**
  String get size;

  /// No description provided for @rotation.
  ///
  /// In pt, this message translates to:
  /// **'Rotação'**
  String get rotation;

  /// No description provided for @imageName.
  ///
  /// In pt, this message translates to:
  /// **'Nome da imagem'**
  String get imageName;

  /// No description provided for @barcodeType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo do código de barras'**
  String get barcodeType;

  /// No description provided for @dataField.
  ///
  /// In pt, this message translates to:
  /// **'Campo representante do dado'**
  String get dataField;

  /// No description provided for @printTextBelowTheBarcode.
  ///
  /// In pt, this message translates to:
  /// **'Imprimir o texto abaixo do código de barras'**
  String get printTextBelowTheBarcode;

  /// No description provided for @alignment.
  ///
  /// In pt, this message translates to:
  /// **'Alinhamento'**
  String get alignment;

  /// No description provided for @format.
  ///
  /// In pt, this message translates to:
  /// **'Formato'**
  String get format;

  /// No description provided for @decimalPlaces.
  ///
  /// In pt, this message translates to:
  /// **'Casas decimais'**
  String get decimalPlaces;

  /// No description provided for @fontType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo da fonte'**
  String get fontType;

  /// No description provided for @fontSize.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho da fonte'**
  String get fontSize;

  /// No description provided for @startingPosition.
  ///
  /// In pt, this message translates to:
  /// **'Posição inicial'**
  String get startingPosition;

  /// No description provided for @maximumCharacters.
  ///
  /// In pt, this message translates to:
  /// **'Máximo de caracteres'**
  String get maximumCharacters;

  /// No description provided for @printBoldText.
  ///
  /// In pt, this message translates to:
  /// **'Imprimir texto em negrito'**
  String get printBoldText;

  /// No description provided for @printReverseText.
  ///
  /// In pt, this message translates to:
  /// **'Imprimir texto reverso'**
  String get printReverseText;

  /// No description provided for @continueAction.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get continueAction;

  /// No description provided for @voidAction.
  ///
  /// In pt, this message translates to:
  /// **'Anular'**
  String get voidAction;

  /// No description provided for @newAction.
  ///
  /// In pt, this message translates to:
  /// **'Novo'**
  String get newAction;

  /// No description provided for @returnAction.
  ///
  /// In pt, this message translates to:
  /// **'Devolver'**
  String get returnAction;

  /// No description provided for @alreadyInModule.
  ///
  /// In pt, this message translates to:
  /// **'Você já está no módulo desejado'**
  String get alreadyInModule;

  /// No description provided for @wholesalePriceLabel.
  ///
  /// In pt, this message translates to:
  /// **'Preço atacado'**
  String get wholesalePriceLabel;

  /// No description provided for @replacementCostPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Custo de reposição '**
  String get replacementCostPrefix;

  /// No description provided for @pricePrefix.
  ///
  /// In pt, this message translates to:
  /// **'Preço '**
  String get pricePrefix;

  /// No description provided for @currentStockPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Estoque atual '**
  String get currentStockPrefix;

  /// No description provided for @availableForSale.
  ///
  /// In pt, this message translates to:
  /// **'Saldo de venda'**
  String get availableForSale;

  /// No description provided for @retailPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Varejo '**
  String get retailPrefix;

  /// No description provided for @minimumRetailPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Mín varejo '**
  String get minimumRetailPrefix;

  /// No description provided for @minimumRetailOfferPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Mín varejo oferta '**
  String get minimumRetailOfferPrefix;

  /// No description provided for @minimumWholesalePrefix.
  ///
  /// In pt, this message translates to:
  /// **'Mín atacado '**
  String get minimumWholesalePrefix;

  /// No description provided for @wholesaleOfferPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Oferta atacado '**
  String get wholesaleOfferPrefix;

  /// No description provided for @minimumEcommercePrefix.
  ///
  /// In pt, this message translates to:
  /// **'Mín ecommerce '**
  String get minimumEcommercePrefix;

  /// No description provided for @minimumEcommerceOfferPrefix.
  ///
  /// In pt, this message translates to:
  /// **'Mín ecommerce oferta '**
  String get minimumEcommerceOfferPrefix;

  /// No description provided for @selectedCompanyAddress.
  ///
  /// In pt, this message translates to:
  /// **'Endereço na empresa selecionada'**
  String get selectedCompanyAddress;

  /// No description provided for @timeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Horário'**
  String get timeLabel;

  /// No description provided for @endOfferAction.
  ///
  /// In pt, this message translates to:
  /// **'Encerrar'**
  String get endOfferAction;

  /// No description provided for @paymentExceedsOrder.
  ///
  /// In pt, this message translates to:
  /// **'O total das formas de pagamento está maior que o total dos produtos!\n'**
  String get paymentExceedsOrder;

  /// No description provided for @customerSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome|Cód|CPF/CNPJ'**
  String get customerSearchHint;

  /// No description provided for @orderChangeImpacts.
  ///
  /// In pt, this message translates to:
  /// **'Esta alteração terá os seguintes impactos no pedido:\n\n'**
  String get orderChangeImpacts;

  /// No description provided for @salesOrdersReadErrors.
  ///
  /// In pt, this message translates to:
  /// **'pedidos de vendas com erros durante a leitura'**
  String get salesOrdersReadErrors;

  /// No description provided for @unmarkSendingAll.
  ///
  /// In pt, this message translates to:
  /// **'Desmarcar envio (todos)'**
  String get unmarkSendingAll;

  /// No description provided for @unmarkSendingSelected.
  ///
  /// In pt, this message translates to:
  /// **'Desmarcar envio (selecionados)'**
  String get unmarkSendingSelected;

  /// No description provided for @notAuthorizer.
  ///
  /// In pt, this message translates to:
  /// **'Você não é um autorizador. Por isso não pode votar nesse processo'**
  String get notAuthorizer;

  /// No description provided for @statusProduct.
  ///
  /// In pt, this message translates to:
  /// **'Status/Produto'**
  String get statusProduct;

  /// No description provided for @settingsLoadFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar as configurações'**
  String get settingsLoadFailed;

  /// No description provided for @autoScanExplanation.
  ///
  /// In pt, this message translates to:
  /// **'Ao ativar essa opção, a câmera será aberta automaticamente para escanear o próximo produto após confirmar uma quantidade'**
  String get autoScanExplanation;

  /// No description provided for @enteredAddresses.
  ///
  /// In pt, this message translates to:
  /// **'Endereços informados'**
  String get enteredAddresses;

  /// No description provided for @privacyConsentRequired.
  ///
  /// In pt, this message translates to:
  /// **'O consentimento de privacidade é obrigatório'**
  String get privacyConsentRequired;

  /// No description provided for @strokeThickness.
  ///
  /// In pt, this message translates to:
  /// **'Espessura do traço'**
  String get strokeThickness;

  /// No description provided for @barcodeRatio.
  ///
  /// In pt, this message translates to:
  /// **'Proporção das barras'**
  String get barcodeRatio;

  /// No description provided for @noCameraAvailable.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma câmera está disponível'**
  String get noCameraAvailable;

  /// No description provided for @centerAlignment.
  ///
  /// In pt, this message translates to:
  /// **'Centro'**
  String get centerAlignment;

  /// No description provided for @printQuality.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade da impressão'**
  String get printQuality;

  /// No description provided for @positioning.
  ///
  /// In pt, this message translates to:
  /// **'Posicionamento'**
  String get positioning;

  /// No description provided for @labelSize.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho da etiqueta'**
  String get labelSize;

  /// No description provided for @barcodeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Código de barras'**
  String get barcodeLabel;

  /// No description provided for @otherOption.
  ///
  /// In pt, this message translates to:
  /// **'Outro'**
  String get otherOption;

  /// No description provided for @paginatedForm.
  ///
  /// In pt, this message translates to:
  /// **'Paginado'**
  String get paginatedForm;

  /// No description provided for @continuousForm.
  ///
  /// In pt, this message translates to:
  /// **'Contínuo'**
  String get continuousForm;

  /// No description provided for @centimeters.
  ///
  /// In pt, this message translates to:
  /// **'Centímetros'**
  String get centimeters;

  /// No description provided for @printerDots.
  ///
  /// In pt, this message translates to:
  /// **'Pontos da impressora'**
  String get printerDots;

  /// No description provided for @agreementLabel.
  ///
  /// In pt, this message translates to:
  /// **'Convênio'**
  String get agreementLabel;

  /// No description provided for @customerCard.
  ///
  /// In pt, this message translates to:
  /// **'Cartão de cliente'**
  String get customerCard;

  /// No description provided for @transportLabel.
  ///
  /// In pt, this message translates to:
  /// **'Transporte'**
  String get transportLabel;

  /// No description provided for @salesOrderProduct.
  ///
  /// In pt, this message translates to:
  /// **'Produto do pedido de venda'**
  String get salesOrderProduct;

  /// No description provided for @unitaryPacking.
  ///
  /// In pt, this message translates to:
  /// **'Unitário'**
  String get unitaryPacking;

  /// No description provided for @multiplePacking.
  ///
  /// In pt, this message translates to:
  /// **'Múltiplo'**
  String get multiplePacking;

  /// No description provided for @bothOptions.
  ///
  /// In pt, this message translates to:
  /// **'Ambos'**
  String get bothOptions;

  /// No description provided for @scaleFactor.
  ///
  /// In pt, this message translates to:
  /// **'fator'**
  String get scaleFactor;

  /// No description provided for @printerCommandValue.
  ///
  /// In pt, this message translates to:
  /// **'valor do comando'**
  String get printerCommandValue;

  /// No description provided for @paymentsWillBeCleared.
  ///
  /// In pt, this message translates to:
  /// **'As formas de pagamento atuais serão removidas'**
  String get paymentsWillBeCleared;

  /// No description provided for @discountsWillBeReset.
  ///
  /// In pt, this message translates to:
  /// **'Os descontos serão removidos'**
  String get discountsWillBeReset;

  /// No description provided for @surchargesWillBeReset.
  ///
  /// In pt, this message translates to:
  /// **'Os acréscimos serão removidos'**
  String get surchargesWillBeReset;

  /// No description provided for @deliveryFeesWillBeReset.
  ///
  /// In pt, this message translates to:
  /// **'As taxas de entrega serão removidas'**
  String get deliveryFeesWillBeReset;

  /// No description provided for @customerBlockedForSales.
  ///
  /// In pt, this message translates to:
  /// **'O cliente selecionado possui bloqueio para vendas'**
  String get customerBlockedForSales;

  /// No description provided for @automaticDiscountsWillBeRemoved.
  ///
  /// In pt, this message translates to:
  /// **'Os descontos automáticos do produto serão removidos'**
  String get automaticDiscountsWillBeRemoved;

  /// No description provided for @noBlockade.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum'**
  String get noBlockade;

  /// No description provided for @offerPriceBlockade.
  ///
  /// In pt, this message translates to:
  /// **'Bloqueio por preço de oferta'**
  String get offerPriceBlockade;

  /// No description provided for @automaticDiscountBlockade.
  ///
  /// In pt, this message translates to:
  /// **'Bloqueio por desconto automático'**
  String get automaticDiscountBlockade;

  /// No description provided for @salesAgreementBlockade.
  ///
  /// In pt, this message translates to:
  /// **'Bloqueio por negociação de venda'**
  String get salesAgreementBlockade;

  /// No description provided for @wholesalePriceBlockade.
  ///
  /// In pt, this message translates to:
  /// **'Bloqueio por preço de atacado'**
  String get wholesalePriceBlockade;

  /// No description provided for @promotionOrigin.
  ///
  /// In pt, this message translates to:
  /// **'Promoção'**
  String get promotionOrigin;

  /// No description provided for @salesAgreementOrigin.
  ///
  /// In pt, this message translates to:
  /// **'Negociação de vendas'**
  String get salesAgreementOrigin;

  /// No description provided for @taxExemptionOrigin.
  ///
  /// In pt, this message translates to:
  /// **'Desoneração'**
  String get taxExemptionOrigin;

  /// No description provided for @employeeBond.
  ///
  /// In pt, this message translates to:
  /// **'Funcionário'**
  String get employeeBond;

  /// No description provided for @simpleUserBond.
  ///
  /// In pt, this message translates to:
  /// **'Simples'**
  String get simpleUserBond;

  /// No description provided for @anyUserCanAuthorize.
  ///
  /// In pt, this message translates to:
  /// **'Qualquer usuário pode autorizar'**
  String get anyUserCanAuthorize;

  /// No description provided for @allUsersShouldAuthorize.
  ///
  /// In pt, this message translates to:
  /// **'Todos os usuários devem autorizar'**
  String get allUsersShouldAuthorize;

  /// No description provided for @closedProcess.
  ///
  /// In pt, this message translates to:
  /// **'Processo encerrado'**
  String get closedProcess;

  /// No description provided for @definedForHandler.
  ///
  /// In pt, this message translates to:
  /// **'Definido para o responsável'**
  String get definedForHandler;

  /// No description provided for @goodsReceiptDocumentValue.
  ///
  /// In pt, this message translates to:
  /// **'Valor do documento no recebimento'**
  String get goodsReceiptDocumentValue;

  /// No description provided for @goodsReceiptDocumentCancellation.
  ///
  /// In pt, this message translates to:
  /// **'Cancelamento de documento no recebimento'**
  String get goodsReceiptDocumentCancellation;

  /// No description provided for @goodsReceiptDocumentRelease.
  ///
  /// In pt, this message translates to:
  /// **'Liberação de documento no recebimento'**
  String get goodsReceiptDocumentRelease;

  /// No description provided for @goodsReceiptXmlValidation.
  ///
  /// In pt, this message translates to:
  /// **'Validação de documento XML no recebimento'**
  String get goodsReceiptXmlValidation;

  /// No description provided for @goodsReceiptPaymentTermsValidation.
  ///
  /// In pt, this message translates to:
  /// **'Validação de condição de pagamento no recebimento'**
  String get goodsReceiptPaymentTermsValidation;

  /// No description provided for @salesOrderBelowMinimumPrice.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de venda com preço abaixo do mínimo'**
  String get salesOrderBelowMinimumPrice;

  /// No description provided for @salesOrderExcessDiscount.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de venda com desconto acima do permitido'**
  String get salesOrderExcessDiscount;

  /// No description provided for @receiptCompleted.
  ///
  /// In pt, this message translates to:
  /// **'Utilizado por uma entrada (Finalizado)'**
  String get receiptCompleted;

  /// No description provided for @receiptCanceled.
  ///
  /// In pt, this message translates to:
  /// **'Cancelado (Finalizado)'**
  String get receiptCanceled;

  /// No description provided for @countingReceiptProducts.
  ///
  /// In pt, this message translates to:
  /// **'Efetuando contagem de produtos'**
  String get countingReceiptProducts;

  /// No description provided for @receiptReleasedAwaitingEntry.
  ///
  /// In pt, this message translates to:
  /// **'Liberado para entrada (Aguardando entrada)'**
  String get receiptReleasedAwaitingEntry;

  /// No description provided for @receiptUnderAuthorization.
  ///
  /// In pt, this message translates to:
  /// **'Em processo de autorização'**
  String get receiptUnderAuthorization;

  /// No description provided for @receiptAwaitingProductMaintenance.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando manutenção de produtos'**
  String get receiptAwaitingProductMaintenance;

  /// No description provided for @receiptAwaitingRelease.
  ///
  /// In pt, this message translates to:
  /// **'Aguardando liberação para entrada'**
  String get receiptAwaitingRelease;

  /// No description provided for @receiptUnknownStatus.
  ///
  /// In pt, this message translates to:
  /// **'Status desconhecido. Avise o suporte'**
  String get receiptUnknownStatus;

  /// No description provided for @orderToInvoiceJudgment.
  ///
  /// In pt, this message translates to:
  /// **'Solicitação para nota fiscal'**
  String get orderToInvoiceJudgment;

  /// No description provided for @invoiceToCountJudgment.
  ///
  /// In pt, this message translates to:
  /// **'Nota fiscal para contagem'**
  String get invoiceToCountJudgment;

  /// No description provided for @orderToCountJudgment.
  ///
  /// In pt, this message translates to:
  /// **'Solicitação para contagem'**
  String get orderToCountJudgment;

  /// No description provided for @moduleDisabledForCompany.
  ///
  /// In pt, this message translates to:
  /// **'O módulo {module} está desabilitado para essa empresa...'**
  String moduleDisabledForCompany(String module);

  /// No description provided for @userMissingResource.
  ///
  /// In pt, this message translates to:
  /// **'Seu usuário não possui permissão para: {resource}'**
  String userMissingResource(String resource);

  /// No description provided for @copiedText.
  ///
  /// In pt, this message translates to:
  /// **'Copiado: {text}'**
  String copiedText(String text);

  /// No description provided for @searchProductsByType.
  ///
  /// In pt, this message translates to:
  /// **'Consultar produtos ({type})'**
  String searchProductsByType(String type);

  /// No description provided for @endNamedOffer.
  ///
  /// In pt, this message translates to:
  /// **'Encerrar oferta {type}'**
  String endNamedOffer(String type);

  /// No description provided for @confirmEndNamedOffer.
  ///
  /// In pt, this message translates to:
  /// **'Tem certeza que deseja encerrar a oferta {type}?'**
  String confirmEndNamedOffer(String type);

  /// No description provided for @paginationRange.
  ///
  /// In pt, this message translates to:
  /// **'{start}-{end} de {total}'**
  String paginationRange(int start, int end, int total);

  /// No description provided for @changeValue.
  ///
  /// In pt, this message translates to:
  /// **'Alterar {value}'**
  String changeValue(String value);

  /// No description provided for @addValue.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar {value}'**
  String addValue(String value);

  /// No description provided for @printingUpdateFailed.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao atualizar impressão: {error}'**
  String printingUpdateFailed(String error);

  /// No description provided for @fromStock.
  ///
  /// In pt, this message translates to:
  /// **'De \"{stock}\"'**
  String fromStock(String stock);

  /// No description provided for @toStock.
  ///
  /// In pt, this message translates to:
  /// **'Para \"{stock}\"'**
  String toStock(String stock);

  /// No description provided for @paymentDifference.
  ///
  /// In pt, this message translates to:
  /// **'Diferença = {amount}'**
  String paymentDifference(String amount);

  /// No description provided for @editingOrderCode.
  ///
  /// In pt, this message translates to:
  /// **'Alterando ({code})'**
  String editingOrderCode(String code);

  /// No description provided for @discountWithSymbol.
  ///
  /// In pt, this message translates to:
  /// **'Desconto {symbol}'**
  String discountWithSymbol(String symbol);

  /// No description provided for @priceWithTypeAbbreviation.
  ///
  /// In pt, this message translates to:
  /// **'Preço R\$ ({type})'**
  String priceWithTypeAbbreviation(String type);

  /// No description provided for @valueWithSymbol.
  ///
  /// In pt, this message translates to:
  /// **'Valor {symbol}'**
  String valueWithSymbol(String symbol);

  /// No description provided for @printOrderCode.
  ///
  /// In pt, this message translates to:
  /// **'Imprimir pedido {code}'**
  String printOrderCode(String code);

  /// No description provided for @priceWithType.
  ///
  /// In pt, this message translates to:
  /// **'Preço {type}'**
  String priceWithType(String type);

  /// No description provided for @companyWithCode.
  ///
  /// In pt, this message translates to:
  /// **'Empresa {code}'**
  String companyWithCode(String code);

  /// No description provided for @websiteProductToLink.
  ///
  /// In pt, this message translates to:
  /// **'Produto do site \"{name}\"\n'**
  String websiteProductToLink(String name);

  /// No description provided for @productToLink.
  ///
  /// In pt, this message translates to:
  /// **'Produto a ser associado \"{name}\"\n'**
  String productToLink(String name);

  /// No description provided for @spreadsheetDownloadedAt.
  ///
  /// In pt, this message translates to:
  /// **'Planilha baixada em \"{path}\"'**
  String spreadsheetDownloadedAt(String path);

  /// No description provided for @salesOrderWithCode.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de venda {code}'**
  String salesOrderWithCode(String code);

  /// No description provided for @unsupportedAuthorizationType.
  ///
  /// In pt, this message translates to:
  /// **'O processo de autorização de tipo \"{type}\" ainda não foi implementado para ser julgado através do aplicativo'**
  String unsupportedAuthorizationType(String type);

  /// No description provided for @documentConferenceCompleted.
  ///
  /// In pt, this message translates to:
  /// **'A conferência do documento {number} foi concluída com sucesso'**
  String documentConferenceCompleted(String number);

  /// No description provided for @conferenceConfirmationFailed.
  ///
  /// In pt, this message translates to:
  /// **'Houve um erro ao tentar confirmar a conferência: {error}'**
  String conferenceConfirmationFailed(String error);

  /// No description provided for @customersCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, one{{count} cliente} other{{count} clientes}}'**
  String customersCount(int count);

  /// No description provided for @requestsCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, one{{count} requisição} other{{count} requisições}}'**
  String requestsCount(int count);

  /// No description provided for @duplicateDataDetails.
  ///
  /// In pt, this message translates to:
  /// **'Essa ação está duplicando dados que não podem ser duplicados. \n{details}'**
  String duplicateDataDetails(String details);

  /// No description provided for @cameraOpenFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível abrir a câmera: {error}'**
  String cameraOpenFailed(String error);

  /// No description provided for @reportId.
  ///
  /// In pt, this message translates to:
  /// **'ID: {id}'**
  String reportId(String id);

  /// No description provided for @layoutFieldsCount.
  ///
  /// In pt, this message translates to:
  /// **'Campos ({count})'**
  String layoutFieldsCount(int count);

  /// No description provided for @labelParametersWithUnit.
  ///
  /// In pt, this message translates to:
  /// **'Parâmetros da etiqueta ({unit})'**
  String labelParametersWithUnit(String unit);

  /// No description provided for @formParametersWithUnit.
  ///
  /// In pt, this message translates to:
  /// **'Parâmetros do formulário ({unit})'**
  String formParametersWithUnit(String unit);

  /// No description provided for @appVersion.
  ///
  /// In pt, this message translates to:
  /// **'Versão {version}'**
  String appVersion(String version);

  /// No description provided for @freeUntilDate.
  ///
  /// In pt, this message translates to:
  /// **'Grátis até {date}'**
  String freeUntilDate(String date);

  /// No description provided for @formattedAddress.
  ///
  /// In pt, this message translates to:
  /// **'{street}, número {number}. {district}, {city}, {state}'**
  String formattedAddress(
    String street,
    String number,
    String district,
    String city,
    String state,
  );

  /// No description provided for @lastChangedQuantity.
  ///
  /// In pt, this message translates to:
  /// **'Última quantidade alterada {sign}'**
  String lastChangedQuantity(String sign);

  /// No description provided for @percentageType.
  ///
  /// In pt, this message translates to:
  /// **'Porcentagem'**
  String get percentageType;

  /// No description provided for @reaisType.
  ///
  /// In pt, this message translates to:
  /// **'Reais'**
  String get reaisType;

  /// No description provided for @withoutJudgment.
  ///
  /// In pt, this message translates to:
  /// **'Sem julgamento'**
  String get withoutJudgment;

  /// No description provided for @acceptedJudgment.
  ///
  /// In pt, this message translates to:
  /// **'Aceito'**
  String get acceptedJudgment;

  /// No description provided for @returnAllJudgment.
  ///
  /// In pt, this message translates to:
  /// **'Devolver tudo'**
  String get returnAllJudgment;

  /// No description provided for @hidePasswordAction.
  ///
  /// In pt, this message translates to:
  /// **'Ocultar'**
  String get hidePasswordAction;

  /// No description provided for @showPasswordAction.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar'**
  String get showPasswordAction;

  /// No description provided for @printerConnectionFailure.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro para conectar com a impressora\n\n\"{error}\"\n\nConfirme se o IP da impressora está correto, se ela está com bobina e se ela está ligada. Caso não resolva, reinicie ela e tente novamente'**
  String printerConnectionFailure(String error);

  /// No description provided for @orderPrintingFailure.
  ///
  /// In pt, this message translates to:
  /// **'Ocorreu um erro ao imprimir o pedido\n\n{error}'**
  String orderPrintingFailure(String error);

  /// No description provided for @printedSalesOrder.
  ///
  /// In pt, this message translates to:
  /// **'PEDIDO DE VENDA {value}'**
  String printedSalesOrder(String value);

  /// No description provided for @printedAt.
  ///
  /// In pt, this message translates to:
  /// **'Impresso em {value}'**
  String printedAt(String value);

  /// No description provided for @printedOrder.
  ///
  /// In pt, this message translates to:
  /// **'Pedido: {value}'**
  String printedOrder(String value);

  /// No description provided for @printedOrderNumber.
  ///
  /// In pt, this message translates to:
  /// **'Pedido Nº: {value}'**
  String printedOrderNumber(String value);

  /// No description provided for @printedOrderTemplate.
  ///
  /// In pt, this message translates to:
  /// **'Modelo de Pedido: {value}'**
  String printedOrderTemplate(String value);

  /// No description provided for @printedIssueDate.
  ///
  /// In pt, this message translates to:
  /// **'Data de Emissao: {value}'**
  String printedIssueDate(String value);

  /// No description provided for @printedCustomer.
  ///
  /// In pt, this message translates to:
  /// **'Cliente: {value}'**
  String printedCustomer(String value);

  /// No description provided for @printedSeller.
  ///
  /// In pt, this message translates to:
  /// **'Vendedor: {value}'**
  String printedSeller(String value);

  /// No description provided for @printedUser.
  ///
  /// In pt, this message translates to:
  /// **'Usuario: {value}'**
  String printedUser(String value);

  /// No description provided for @printedSurcharge.
  ///
  /// In pt, this message translates to:
  /// **'Acrescimo: {value}'**
  String printedSurcharge(String value);

  /// No description provided for @printedPaymentDiscount.
  ///
  /// In pt, this message translates to:
  /// **'Desconto Financeiro: {value}'**
  String printedPaymentDiscount(String value);

  /// No description provided for @printedPaymentSurcharge.
  ///
  /// In pt, this message translates to:
  /// **'Acrescimo Financeiro: {value}'**
  String printedPaymentSurcharge(String value);

  /// No description provided for @printedShipping.
  ///
  /// In pt, this message translates to:
  /// **'Frete: {value}'**
  String printedShipping(String value);

  /// No description provided for @printedNetTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total Liquido: R\$ {value}'**
  String printedNetTotal(String value);

  /// No description provided for @printedInstallments.
  ///
  /// In pt, this message translates to:
  /// **' em {value}x'**
  String printedInstallments(String value);

  /// No description provided for @printedDiscountAmount.
  ///
  /// In pt, this message translates to:
  /// **'  (-) Desconto: R\$ {value}'**
  String printedDiscountAmount(String value);

  /// No description provided for @printedSurchargeAmount.
  ///
  /// In pt, this message translates to:
  /// **'  (+) Acrescimo: R\$ {value}'**
  String printedSurchargeAmount(String value);

  /// No description provided for @printedItemDiscount.
  ///
  /// In pt, this message translates to:
  /// **'Desconto -{value}'**
  String printedItemDiscount(String value);

  /// No description provided for @printedItemSurcharge.
  ///
  /// In pt, this message translates to:
  /// **'Acrescimo +{value}'**
  String printedItemSurcharge(String value);

  /// No description provided for @printedItemShipping.
  ///
  /// In pt, this message translates to:
  /// **'Frete +{value}'**
  String printedItemShipping(String value);

  /// No description provided for @removedPaymentMethods.
  ///
  /// In pt, this message translates to:
  /// **'As seguintes formas de pagamento serão removidas: {methods}'**
  String removedPaymentMethods(String methods);

  /// No description provided for @customerSalesBlockDetails.
  ///
  /// In pt, this message translates to:
  /// **'O cliente possui bloqueio para vendas: {details}'**
  String customerSalesBlockDetails(String details);

  /// No description provided for @confirmOrderChangeImpacts.
  ///
  /// In pt, this message translates to:
  /// **'Esta alteração terá os seguintes impactos no pedido:\n\n{impacts}\n\nDeseja prosseguir?'**
  String confirmOrderChangeImpacts(String impacts);

  /// No description provided for @layoutNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Nome: Este campo é de preenchimento obrigatório'**
  String get layoutNameRequired;

  /// No description provided for @layoutPrinterRequired.
  ///
  /// In pt, this message translates to:
  /// **'Impressora: A impressora não foi informada'**
  String get layoutPrinterRequired;

  /// No description provided for @layoutFormWidthInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Largura do formulário: Informe um valor maior que zero'**
  String get layoutFormWidthInvalid;

  /// No description provided for @layoutFormHeightInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Altura do formulário: Informe um valor maior que zero'**
  String get layoutFormHeightInvalid;

  /// No description provided for @layoutColumnsInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade de colunas: Informe um valor maior que zero'**
  String get layoutColumnsInvalid;

  /// No description provided for @layoutWidthInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Largura da etiqueta: Informe um valor maior que zero'**
  String get layoutWidthInvalid;

  /// No description provided for @layoutHeightInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Altura da etiqueta: Informe um valor maior que zero'**
  String get layoutHeightInvalid;

  /// No description provided for @layoutFormMarginsInvalid.
  ///
  /// In pt, this message translates to:
  /// **'As margens do formulário não podem ser negativas'**
  String get layoutFormMarginsInvalid;

  /// No description provided for @layoutLabelMarginsInvalid.
  ///
  /// In pt, this message translates to:
  /// **'As margens da etiqueta não podem ser negativas'**
  String get layoutLabelMarginsInvalid;

  /// No description provided for @layoutTemperatureRequired.
  ///
  /// In pt, this message translates to:
  /// **'Temperatura de impressão: Selecione uma opção'**
  String get layoutTemperatureRequired;

  /// No description provided for @layoutSpeedRequired.
  ///
  /// In pt, this message translates to:
  /// **'Velocidade de impressão: Selecione uma opção'**
  String get layoutSpeedRequired;

  /// No description provided for @layoutIntervalInvalid.
  ///
  /// In pt, this message translates to:
  /// **'Intervalo entre pacotes deve ser maior que zero'**
  String get layoutIntervalInvalid;

  /// No description provided for @layoutFormSizeRequired.
  ///
  /// In pt, this message translates to:
  /// **'A configuração do tamanho do formulário deve ser aplicada'**
  String get layoutFormSizeRequired;

  /// No description provided for @layoutAddressRequired.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de endereço: Selecione uma opção'**
  String get layoutAddressRequired;

  /// No description provided for @layoutAddressInapplicable.
  ///
  /// In pt, this message translates to:
  /// **'O tipo de endereço não se aplica ao tipo de leiaute'**
  String get layoutAddressInapplicable;

  /// No description provided for @layoutFieldRequired.
  ///
  /// In pt, this message translates to:
  /// **'Informe pelo menos um campo para o leiaute'**
  String get layoutFieldRequired;

  /// No description provided for @layoutFieldInapplicable.
  ///
  /// In pt, this message translates to:
  /// **'Existe pelo menos um campo que não se aplica ao tipo de leiaute informado'**
  String get layoutFieldInapplicable;

  /// No description provided for @layoutLabelsExceedForm.
  ///
  /// In pt, this message translates to:
  /// **'As etiquetas não cabem na largura do formulário'**
  String get layoutLabelsExceedForm;

  /// No description provided for @noSelectedCompany.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma empresa selecionada. Carregue os dados novamente'**
  String get noSelectedCompany;

  /// No description provided for @noCameraAvailableFailure.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma câmera está disponível'**
  String get noCameraAvailableFailure;

  /// No description provided for @reportContextUnavailable.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar o contexto do relatório'**
  String get reportContextUnavailable;

  /// No description provided for @reportSavedLayoutRequired.
  ///
  /// In pt, this message translates to:
  /// **'Somente um leiaute salvo pode ser relatado'**
  String get reportSavedLayoutRequired;

  /// No description provided for @reportImagesRequired.
  ///
  /// In pt, this message translates to:
  /// **'As duas imagens do relatório devem ser informadas'**
  String get reportImagesRequired;

  /// No description provided for @reportCategoryRequired.
  ///
  /// In pt, this message translates to:
  /// **'A categoria deve ser informada'**
  String get reportCategoryRequired;

  /// No description provided for @reportPrivacyRequired.
  ///
  /// In pt, this message translates to:
  /// **'O consentimento de privacidade é obrigatório'**
  String get reportPrivacyRequired;

  /// No description provided for @processTypeUnsupported.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de processo não implementado'**
  String get processTypeUnsupported;

  /// No description provided for @reportValidationUnsupportedSchema.
  ///
  /// In pt, this message translates to:
  /// **'Versão do formato não suportada'**
  String get reportValidationUnsupportedSchema;

  /// No description provided for @reportValidationInvalidIdempotencyKey.
  ///
  /// In pt, this message translates to:
  /// **'A chave de identificação deve ser um UUID'**
  String get reportValidationInvalidIdempotencyKey;

  /// No description provided for @reportValidationSupabaseEnterpriseRequired.
  ///
  /// In pt, this message translates to:
  /// **'A empresa do aplicativo deve ser informada'**
  String get reportValidationSupabaseEnterpriseRequired;

  /// No description provided for @reportValidationErpEnterpriseRequired.
  ///
  /// In pt, this message translates to:
  /// **'A empresa do ERP deve ser informada'**
  String get reportValidationErpEnterpriseRequired;

  /// No description provided for @reportValidationErpUserRequired.
  ///
  /// In pt, this message translates to:
  /// **'O nome do usuário do ERP deve ser informado'**
  String get reportValidationErpUserRequired;

  /// No description provided for @reportValidationErpUserTooLong.
  ///
  /// In pt, this message translates to:
  /// **'O nome do usuário do ERP deve conter no máximo 200 caracteres'**
  String get reportValidationErpUserTooLong;

  /// No description provided for @reportValidationErpCompanyRequired.
  ///
  /// In pt, this message translates to:
  /// **'O nome da empresa do ERP deve ser informado'**
  String get reportValidationErpCompanyRequired;

  /// No description provided for @reportValidationErpCompanyTooLong.
  ///
  /// In pt, this message translates to:
  /// **'O nome da empresa do ERP deve conter no máximo 200 caracteres'**
  String get reportValidationErpCompanyTooLong;

  /// No description provided for @reportValidationReportDescriptionRequired.
  ///
  /// In pt, this message translates to:
  /// **'A descrição deve ser informada'**
  String get reportValidationReportDescriptionRequired;

  /// No description provided for @reportValidationReportDescriptionTooLong.
  ///
  /// In pt, this message translates to:
  /// **'A descrição deve conter no máximo 2000 caracteres'**
  String get reportValidationReportDescriptionTooLong;

  /// No description provided for @reportValidationSavedLayoutRequired.
  ///
  /// In pt, this message translates to:
  /// **'Somente um leiaute salvo pode ser relatado'**
  String get reportValidationSavedLayoutRequired;

  /// No description provided for @reportValidationEnvironmentRequired.
  ///
  /// In pt, this message translates to:
  /// **'Os dados do ambiente devem estar completos'**
  String get reportValidationEnvironmentRequired;

  /// No description provided for @reportValidationPhysicalImageTooLarge.
  ///
  /// In pt, this message translates to:
  /// **'A foto da etiqueta deve ter no máximo 5 MiB'**
  String get reportValidationPhysicalImageTooLarge;

  /// No description provided for @reportValidationPhysicalImageDimensionsInvalid.
  ///
  /// In pt, this message translates to:
  /// **'As dimensões da foto da etiqueta são inválidas'**
  String get reportValidationPhysicalImageDimensionsInvalid;

  /// No description provided for @reportValidationCanvasImageTooLarge.
  ///
  /// In pt, this message translates to:
  /// **'A imagem da pré-visualização deve ter no máximo 5 MiB'**
  String get reportValidationCanvasImageTooLarge;

  /// No description provided for @reportValidationCanvasImageDimensionsInvalid.
  ///
  /// In pt, this message translates to:
  /// **'As dimensões da imagem da pré-visualização são inválidas'**
  String get reportValidationCanvasImageDimensionsInvalid;

  /// No description provided for @reportValidationCapturesNotConfirmed.
  ///
  /// In pt, this message translates to:
  /// **'As duas capturas devem ser confirmadas'**
  String get reportValidationCapturesNotConfirmed;

  /// No description provided for @deactivatedProperty.
  ///
  /// In pt, this message translates to:
  /// **'Desativado'**
  String get deactivatedProperty;

  /// No description provided for @fiscalClassificationProperty.
  ///
  /// In pt, this message translates to:
  /// **'Classificacao fiscal'**
  String get fiscalClassificationProperty;

  /// No description provided for @labelPhotoUploadTooLarge.
  ///
  /// In pt, this message translates to:
  /// **'A foto da etiqueta não pôde ser convertida dentro do limite de envio.'**
  String get labelPhotoUploadTooLarge;

  /// No description provided for @labelCanvasUploadTooLarge.
  ///
  /// In pt, this message translates to:
  /// **'A pré-visualização excede o limite de envio.'**
  String get labelCanvasUploadTooLarge;

  /// No description provided for @labelCanvasDecodeFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível decodificar os pixels da pré-visualização.'**
  String get labelCanvasDecodeFailed;

  /// No description provided for @labelCanvasUnreadable.
  ///
  /// In pt, this message translates to:
  /// **'A pré-visualização não é uma imagem legível.'**
  String get labelCanvasUnreadable;

  /// No description provided for @labelCanvasWebpUnreadable.
  ///
  /// In pt, this message translates to:
  /// **'A pré-visualização convertida não é uma imagem WebP legível.'**
  String get labelCanvasWebpUnreadable;

  /// No description provided for @labelCanvasBlank.
  ///
  /// In pt, this message translates to:
  /// **'A pré-visualização convertida não possui conteúdo visível.'**
  String get labelCanvasBlank;

  /// No description provided for @labelImageWebpUnreadable.
  ///
  /// In pt, this message translates to:
  /// **'A imagem convertida não é um arquivo WebP legível.'**
  String get labelImageWebpUnreadable;

  /// No description provided for @labelImageFileMissing.
  ///
  /// In pt, this message translates to:
  /// **'O arquivo de imagem não foi encontrado ou está vazio.'**
  String get labelImageFileMissing;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
