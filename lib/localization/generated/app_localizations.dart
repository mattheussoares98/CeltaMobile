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
