import 'dart:typed_data';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_cost/domain/entity/entity.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/models/models.dart';
import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_inventario/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_inventario/features/inventory/domain/entities/entities.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';
import 'package:celta_inventario/features/reports/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static EnterpriseEntity makeEnterpriseEntity({
    int? id,
    String? name,
    int? code,
    bool? enterpriseParticipateEnterpriseGroup,
    bool? annulEnterpriseId,
  }) => EnterpriseEntity(
    id: annulEnterpriseId == true
        ? null
        : id ?? faker.randomGenerator.integer(100),
    name: name ?? faker.company.name(),
    workingUrl: faker.internet.httpsUrl(),
    localHttpUrl: faker.internet.httpUrl(),
    localHttpsUrl: faker.internet.httpsUrl(),
    remoteHttpUrl: faker.internet.httpUrl(),
    remoteHttpsUrl: faker.internet.httpsUrl(),
    FantasizesName: faker.company.name(),
    SaleRequestTypeCode: faker.randomGenerator.integer(100),
    subEnterprises: [
      makeSubEnterpriseEntity(),
      makeSubEnterpriseEntity(),
      makeSubEnterpriseEntity(),
    ],
    CnpjNumber: faker.randomGenerator.integer(100).toString(),
    Code: code ?? faker.randomGenerator.integer(100),
    CodigoInternoVendaMobile_ModeloPedido: faker.randomGenerator.integer(100),
    ProductCodeSizeOfBalanceLabel: faker.randomGenerator.integer(6),
    PersonalizedCode: faker.randomGenerator.integer(100).toString(),
    InscriptionNumber: faker.randomGenerator.integer(100).toString(),
    EnterpriseParticipateEnterpriseGroup:
        enterpriseParticipateEnterpriseGroup ?? faker.randomGenerator.boolean(),
    ProductCodeWithCheckerDigit: faker.randomGenerator.boolean(),
    UseEcommerceSale: faker.randomGenerator.boolean(),
    UseRetailSale: faker.randomGenerator.boolean(),
    UseWholeSale: faker.randomGenerator.boolean(),
  );

  static SubEnterpriseEntity makeSubEnterpriseEntity({String? cnpjNumber}) =>
      SubEnterpriseEntity(
        id: faker.randomGenerator.integer(100),
        idFromErp: faker.randomGenerator.integer(100),
        personalizedCode: faker.randomGenerator.integer(100).toString(),
        name: faker.company.name(),
        cnpjNumber: cnpjNumber ?? faker.randomGenerator.numberOfLength(14),
      );

  static UserEntity makeUserEntity({bool? annullName}) => UserEntity(
    name: annullName == true ? null : faker.person.name(),
    enterpriseName: faker.company.name(),
    AccessKey: faker.guid.guid(),
    CrossIdentity_Usuario: faker.guid.guid(),
    CodigoInterno_Usuario: faker.randomGenerator.integer(100),
  );

  static EnterprisePermissionEntity makeEnterprisePermissionEntity() =>
      EnterprisePermissionEntity(
        id: faker.randomGenerator.integer(100),
        name: faker.company.name(),
        remoteHttpUrl: faker.internet.httpUrl(),
        remoteHttpsUrl: faker.internet.httpsUrl(),
        localHttpUrl: faker.internet.httpUrl(),
        localHttpsUrl: faker.internet.httpsUrl(),
        globalModules: [
          makeModulePermissionEntity(),
          makeModulePermissionEntity(),
          makeModulePermissionEntity(),
        ],
        subEnterprises: [
          makeSubEnterprisePermissionEntity(),
          makeSubEnterprisePermissionEntity(),
          makeSubEnterprisePermissionEntity(),
        ],
      );

  static SubEnterprisePermissionEntity makeSubEnterprisePermissionEntity() =>
      SubEnterprisePermissionEntity(
        id: faker.randomGenerator.integer(100),
        name: faker.company.name(),
        cnpjNumber: faker.randomGenerator.integer(200).toString(),
        personalizedCode: faker.randomGenerator.integer(100).toString(),
        modules: [
          makeModulePermissionEntity(),
          makeModulePermissionEntity(),
          makeModulePermissionEntity(),
        ],
      );

  static ModulePermissionEntity makeModulePermissionEntity() =>
      ModulePermissionEntity(
        id: faker.randomGenerator.integer(100),
        moduleKey: faker.guid.guid(),
        name: faker.lorem.word(),
        isEnabled: faker.randomGenerator.boolean(),
        isDefinedAtCnpjLevel: faker.randomGenerator.boolean(),
      );

  static ProductEntity makeProductEntity({
    int? enterpriseCode,
    int? productCode,
    int? productPackingCode,
    double? MinimumWholeQuantity,
    double? RetailPracticedPrice,
    String? plu,
    double? Quantidade_ProcRecebDocProEmb,
    DateTime? DataValidade_ProcRecebDocProEmb,
    bool? isFatherOfGrate,
    bool? isChildOfGrate,
    bool? inClass,
    bool? alterationPriceForAllPackings,
    bool? markUpdateClassInAdjustSalePriceIndividual,
  }) => ProductEntity(
    PackingAbbreviation: faker.lorem.word(),
    ConcurrentCode: faker.randomGenerator.integer(100),
    ResearchOfPriceCode: faker.randomGenerator.integer(100),
    EANs: [
      faker.randomGenerator.integer(100).toString(),
      faker.randomGenerator.integer(100).toString(),
      faker.randomGenerator.integer(100).toString(),
    ],
    EnterpriseCode: enterpriseCode ?? faker.randomGenerator.integer(100),
    ProductCode: productCode ?? faker.randomGenerator.integer(100),
    ProductPackingCode:
        productPackingCode ?? faker.randomGenerator.integer(999999),
    PLU: plu ?? faker.randomGenerator.integer(100).toString(),
    Name: faker.food.dish(),
    PackingQuantity: faker.randomGenerator.integer(100).toString(),
    BalanceLabelType: faker.lorem.word(),
    StorageAreaAddress: faker.address.streetAddress(),
    Value: faker.randomGenerator.decimal(),
    BalanceLabelQuantity: faker.randomGenerator.decimal(),
    RetailPracticedPrice:
        RetailPracticedPrice ?? faker.randomGenerator.decimal(),
    RetailSalePrice: faker.randomGenerator.decimal(),
    RetailOfferPrice: faker.randomGenerator.decimal(),
    WholePracticedPrice: faker.randomGenerator.decimal(),
    WholeSalePrice: faker.randomGenerator.decimal(),
    WholeOfferPrice: faker.randomGenerator.decimal(),
    ECommercePracticedPrice: faker.randomGenerator.decimal(),
    ECommerceSalePrice: faker.randomGenerator.decimal(),
    ECommerceOfferPrice: faker.randomGenerator.decimal(),
    MinimumWholeQuantity:
        MinimumWholeQuantity ?? faker.randomGenerator.decimal(),
    OperationalCost: faker.randomGenerator.decimal(),
    ReplacementCost: faker.randomGenerator.decimal(),
    ReplacementCostMidle: faker.randomGenerator.decimal(),
    LiquidCost: faker.randomGenerator.decimal(),
    LiquidCostMidle: faker.randomGenerator.decimal(),
    RealCost: faker.randomGenerator.decimal(),
    RealLiquidCost: faker.randomGenerator.decimal(),
    FiscalCost: faker.randomGenerator.decimal(),
    FiscalLiquidCost: faker.randomGenerator.decimal(),
    PendantPrintLabel: faker.randomGenerator.boolean(),
    AlterationPriceForAllPackings:
        alterationPriceForAllPackings ?? faker.randomGenerator.boolean(),
    IsFatherOfGrate: isFatherOfGrate ?? faker.randomGenerator.boolean(),
    IsChildOfGrate: isChildOfGrate ?? faker.randomGenerator.boolean(),
    InClass: inClass ?? faker.randomGenerator.boolean(),
    MarkUpdateClassInAdjustSalePriceIndividual:
        markUpdateClassInAdjustSalePriceIndividual ??
        faker.randomGenerator.boolean(),
    PriceCost: makePriceCost(),
    StockByEnterpriseAssociateds: [
      makeStockByEnterpriseAssociatedEntity(),
      makeStockByEnterpriseAssociatedEntity(),
      makeStockByEnterpriseAssociatedEntity(),
    ],
    Stocks: [makeStockEntity(), makeStockEntity(), makeStockEntity()],
    LastBuyEntrances: [
      makeLastBuyEntranceEntity(),
      makeLastBuyEntranceEntity(),
      makeLastBuyEntranceEntity(),
    ],
    codigoInternoProEmb: faker.randomGenerator.integer(100),
    codigoProEmb: faker.randomGenerator.integer(100).toString(),
    quantidadeInvContProEmb: faker.randomGenerator.decimal(),
    FormatedProduct: faker.lorem.sentence(),
    DataValidade_ProcRecebDocProEmb:
        DataValidade_ProcRecebDocProEmb ?? faker.date.dateTime(),
    Quantidade_ProcRecebDocProEmb:
        Quantidade_ProcRecebDocProEmb ?? faker.randomGenerator.decimal(),
    ReferenciaXml_ProcRecebDocProEmb: faker.lorem.word(),
  );

  static LastBuyEntranceEntity makeLastBuyEntranceEntity() =>
      LastBuyEntranceEntity(
        Number: faker.randomGenerator.integer(100).toString(),
        EntranceDate: faker.date.dateTime().toIso8601String(),
        Supplier: faker.company.name(),
        FiscalCode: faker.randomGenerator.integer(100).toString(),
        Packing: faker.lorem.word(),
        Quantity: faker.randomGenerator.decimal(),
      );

  static StockEntity makeStockEntity() => StockEntity(
    EnterpriseCode: faker.randomGenerator.integer(100),
    Enterprise: faker.company.name(),
    StockName: faker.lorem.word(),
    StockQuantity: faker.randomGenerator.decimal(),
  );

  static StockByEnterpriseAssociatedEntity
  makeStockByEnterpriseAssociatedEntity() => StockByEnterpriseAssociatedEntity(
    Enterprise: faker.company.name(),
    StorageAreaAddress: [
      faker.address.streetAddress(),
      faker.address.streetAddress(),
      faker.address.streetAddress(),
    ],
    StockBalanceForSale: faker.randomGenerator.decimal(),
  );

  static PriceCostEntity makePriceCost() => PriceCostEntity(
    RetailPracticedPrice: faker.randomGenerator.decimal(),
    RetailSalePrice: faker.randomGenerator.decimal(),
    RetailOfferPrice: faker.randomGenerator.decimal(),
    RetailSuggestionPrice: faker.randomGenerator.decimal(),
    RetailMinimumPrice: faker.randomGenerator.decimal(),
    WholePracticedPrice: faker.randomGenerator.decimal(),
    WholeSalePrice: faker.randomGenerator.decimal(),
    WholeOfferPrice: faker.randomGenerator.decimal(),
    WholeSuggestionPrice: faker.randomGenerator.decimal(),
    WholeMinimumPrice: faker.randomGenerator.decimal(),
    ECommercePracticedPrice: faker.randomGenerator.decimal(),
    ECommerceSalePrice: faker.randomGenerator.decimal(),
    ECommerceOfferPrice: faker.randomGenerator.decimal(),
    ECommerceSuggestionPrice: faker.randomGenerator.decimal(),
    ECommerceMinimumPrice: faker.randomGenerator.decimal(),
    MinimumWholeQuantity: faker.randomGenerator.decimal(),
    OperationalCost: faker.randomGenerator.decimal(),
    ReplacementCost: faker.randomGenerator.decimal(),
    ReplacementCostMidle: faker.randomGenerator.decimal(),
    LiquidCost: faker.randomGenerator.decimal(),
    LiquidCostMidle: faker.randomGenerator.decimal(),
    RealCost: faker.randomGenerator.decimal(),
    RealLiquidCost: faker.randomGenerator.decimal(),
    FiscalCost: faker.randomGenerator.decimal(),
    FiscalLiquidCost: faker.randomGenerator.decimal(),
    RetailMargin: faker.randomGenerator.decimal(),
    RetailOfferMargin: faker.randomGenerator.decimal(),
    RetailMinimumMargin: faker.randomGenerator.decimal(),
    WholeMargin: faker.randomGenerator.decimal(),
    WholeOfferMargin: faker.randomGenerator.decimal(),
    WholeMinimumMargin: faker.randomGenerator.decimal(),
    ECommerceMargin: faker.randomGenerator.decimal(),
    ECommerceOfferMargin: faker.randomGenerator.decimal(),
    ECommerceMinimumMargin: faker.randomGenerator.decimal(),
  );

  static UserSessionEntity makeUserSessionEntity({
    int? selectedEnterpriseCode,
  }) => UserSessionEntity(
    user: makeUserEntity(),
    supabaseEnterprise: makeEnterpriseEntity(),
    selectedEnterprise: makeEnterpriseEntity(code: selectedEnterpriseCode),
  );

  static PriceScheduleEntity makePriceScheduleEntity() => PriceScheduleEntity(
    Code: faker.randomGenerator.integer(100),
    FatherCode: faker.randomGenerator.integer(100),
    BrotherCode: faker.randomGenerator.integer(100),
    PriceType: faker.randomGenerator.integer(100),
    Origin: faker.randomGenerator.integer(100),
    User: faker.internet.userName(),
    PriceTypeString: faker.randomGenerator.integer(100).toString(),
    OriginString: faker.randomGenerator.integer(100).toString(),
    OfferSchedule: faker.randomGenerator.string(5),
    Date: faker.date.dateTime(),
    ExecutionDate: faker.date.dateTime(),
    ExecutedDate: faker.date.dateTime(),
    OriginalPrice: faker.randomGenerator.decimal(),
    Price: faker.randomGenerator.decimal(),
    LastPrice: faker.randomGenerator.decimal(),
    RoundedPrice: faker.randomGenerator.boolean(),
    AlteredByEnterpriseGroup: faker.randomGenerator.boolean(),
    AlteredByClass: faker.randomGenerator.boolean(),
    AlteredByPackings: faker.randomGenerator.boolean(),
    AlteredByGrid: faker.randomGenerator.boolean(),
    UpdateClass: faker.randomGenerator.boolean(),
    UpdateEnterpriseOperationalGroup: faker.randomGenerator.boolean(),
    IsFather: faker.randomGenerator.boolean(),
    IsBrother: faker.randomGenerator.boolean(),
    IsExecuted: faker.randomGenerator.boolean(),
    IsFinished: faker.randomGenerator.boolean(),
  );

  static AppSettingsEntity makeAppSettingsEntity() => AppSettingsEntity(
    searchPreference:
        SearchProductTypePreference.values[faker.randomGenerator.integer(
          SearchProductTypePreference.values.length,
        )],
    inventoryUseContinuousScan: faker.randomGenerator.boolean(),
    expeditionUseContinuousScan: faker.randomGenerator.boolean(),
    receiptUseContinuousScan: faker.randomGenerator.boolean(),
  );

  static TransferJustificationEntity makeTransferJustificationEntity({
    int? CodigoInterno_TipoEstoque,
  }) => TransferJustificationEntity(
    CodigoInterno_JustMov: faker.randomGenerator.integer(100),
    Descricao_JustMov: faker.lorem.word(),
    operationType: OperationType
        .values[faker.randomGenerator.integer(OperationType.values.length)],
    FlagInterno_TipoEstoque: faker.randomGenerator.boolean(),
    Nome_TipoEstoque: faker.lorem.word(),
    CodigoInterno_TipoEstoque:
        CodigoInterno_TipoEstoque ?? faker.randomGenerator.integer(100),
  );

  static StockTypeEntity makeStockTypeEntity({
    int? CodigoInterno_TipoEstoque,
  }) => StockTypeEntity(
    CodigoInterno_TipoEstoque:
        CodigoInterno_TipoEstoque ?? faker.randomGenerator.integer(100),
    Nome_TipoEstoque: faker.lorem.word(),
    FlagInterno_TipoEstoque: faker.randomGenerator.boolean(),
  );

  static AdjustStockItemEntity makeAdjustStockItemEntity() =>
      AdjustStockItemEntity(
        EnterpriseCode: faker.randomGenerator.integer(100),
        ProductCode: faker.randomGenerator.integer(100),
        ProductPackingCode: faker.randomGenerator.integer(100),
        JustificationCode: faker.randomGenerator.integer(100),
        StockTypeCode: faker.randomGenerator.integer(100),
        StockTypeRecipientCode: faker.randomGenerator.integer(100),
        IsPendingAdjust: faker.randomGenerator.boolean(),
        Quantity: faker.randomGenerator.decimal(),
      );

  static ProductLotInfoEntity makeProductLotInfoEntity() =>
      ProductLotInfoEntity(
        product: ProductModel.fromEntity(makeProductEntity()).toEntity(),
        selectedJustification: makeTransferJustificationEntity(),
        selectedOriginStock: makeStockTypeEntity(),
        selectedDestinyStock: makeStockTypeEntity(),
        quantity: faker.randomGenerator.decimal(),
      );

  static EnabledModulesByCnpjEntity makeEnabledModulesByCnpjEntity() =>
      EnabledModulesByCnpjEntity(
        idFromErp: faker.randomGenerator.integer(100),
        cnpjNumber: faker.randomGenerator.integer(100).toString(),
        name: faker.company.name(),
        enabledModules: Modules.values,
      );

  static SoapCustomerEntity makeCustomerEntity() => SoapCustomerEntity(
    Name: faker.person.name(),
    Code: faker.randomGenerator.integer(100),
    PersonalizedCode: faker.randomGenerator.integer(100).toString(),
    ReducedName: faker.person.name(),
    CpfCnpjNumber: faker.randomGenerator.integer(100).toString(),
    RegistrationNumber: faker.guid.guid(),
    Password: faker.guid.guid(),
    HasPassword: faker.randomGenerator.boolean(),
    DateOfBirth: faker.date.dateTime(),
    SexType: CustomerSexType.values[faker.randomGenerator.integer(2)],
    PersonType:
        CustomerPersonType.values[faker.randomGenerator.integer(
          CustomerPersonType.values.length,
        )],
    Emails: [
      faker.internet.email(),
      faker.internet.email(),
      faker.internet.email(),
    ],
    Telephones: [
      makeCustomerTelephoneEntity(),
      makeCustomerTelephoneEntity(),
      makeCustomerTelephoneEntity(),
    ],
    Addresses: [makeAddressEntity(), makeAddressEntity(), makeAddressEntity()],
    CustomerCovenants: [
      makeCustomerCovenantEntity(),
      makeCustomerCovenantEntity(),
      makeCustomerCovenantEntity(),
    ],
    saleBlockadeInstruction: makeCustomerSaleBlockadeInstructionEntity(),
    saleBlockade: makeCustomerSaleBlockadeEntity(),
  );

  static CustomerTelephoneEntity makeCustomerTelephoneEntity() =>
      CustomerTelephoneEntity(
        AreaCode: faker.randomGenerator.integer(100).toString(),
        PhoneNumber: faker.phoneNumber.us(),
      );

  static AddressEntity makeAddressEntity() => AddressEntity(
    Zip: faker.address.zipCode(),
    Address: faker.address.streetAddress(),
    Number: faker.randomGenerator.integer(100).toString(),
    District: faker.address.city(),
    City: faker.address.city(),
    State: BrazilStates
        .values[faker.randomGenerator.integer(BrazilStates.values.length)],
    Complement: faker.address.neighborhood(),
    Reference: faker.address.neighborhood(),
  );

  static CustomerCovenantEntity makeCustomerCovenantEntity() =>
      CustomerCovenantEntity(
        covenant: makeCovenantInfoEntity(),
        Matriculate: faker.guid.guid(),
        LimitOfPurchase: faker.randomGenerator.decimal(),
      );

  static CovenantInfoEntity makeCovenantInfoEntity() => CovenantInfoEntity(
    Code: faker.randomGenerator.integer(100),
    PersonalizedCode: faker.randomGenerator.integer(100).toString(),
    Name: faker.company.name(),
  );

  static CustomerSaleBlockadeInstructionEntity
  makeCustomerSaleBlockadeInstructionEntity() =>
      CustomerSaleBlockadeInstructionEntity(
        Code: faker.randomGenerator.integer(100),
        PersonalizedCode: faker.randomGenerator.integer(100).toString(),
        LegacyCode: faker.lorem.word(),
        Description: faker.lorem.sentence(),
      );

  static CustomerSaleBlockadeEntity makeCustomerSaleBlockadeEntity() =>
      CustomerSaleBlockadeEntity(
        Code: faker.randomGenerator.integer(100),
        PersonalizedCode: faker.randomGenerator.integer(100).toString(),
        LegacyCode: faker.randomGenerator.integer(100).toString(),
        Description: faker.lorem.sentence(),
        AllowSaleRequest: faker.randomGenerator.boolean(),
        AllowSale: faker.randomGenerator.boolean(),
        AllowSaleWithPaymentFinalizationTypeCheckOrPortion: faker
            .randomGenerator
            .boolean(),
      );

  static CovenantEntity makeCovenantEntity() => CovenantEntity(
    Codigo_Convenio: faker.lorem.word(),
    Cnpj_Convenio: faker.lorem.word(),
    InscricaoEstadual_Convenio: faker.lorem.word(),
    Nome_Convenio: faker.lorem.word(),
    NomeFantasia_Convenio: faker.lorem.word(),
    DataCadastro_Convenio: faker.lorem.word(),
    EMail_Convenio: faker.lorem.word(),
    Contato_Convenio: faker.lorem.word(),
    DataNascimentoContato_Convenio: faker.lorem.word(),
    Logradouro_Convenio: faker.lorem.word(),
    NumEndereco_Convenio: faker.lorem.word(),
    Cep_Convenio: faker.lorem.word(),
    Cidade_Convenio: faker.lorem.word(),
    Bairro_Convenio: faker.lorem.word(),
    Estado_Convenio: faker.lorem.word(),
    Complemento_Convenio: faker.lorem.word(),
    Referencia_Convenio: faker.lorem.word(),
    LogradouroEntrega_Convenio: faker.lorem.word(),
    NumEnderecoEntrega_Convenio: faker.lorem.word(),
    CepEntrega_Convenio: faker.lorem.word(),
    CidadeEntrega_Convenio: faker.lorem.word(),
    BairroEntrega_Convenio: faker.lorem.word(),
    EstadoEntrega_Convenio: faker.lorem.word(),
    ComplementoEntrega_Convenio: faker.lorem.word(),
    ReferenciaEntrega_Convenio: faker.lorem.word(),
    LogradouroCobranca_Convenio: faker.lorem.word(),
    NumEnderecoCobranca_Convenio: faker.lorem.word(),
    CepCobranca_Convenio: faker.lorem.word(),
    CidadeCobranca_Convenio: faker.lorem.word(),
    BairroCobranca_Convenio: faker.lorem.word(),
    EstadoCobranca_Convenio: faker.lorem.word(),
    ComplementoCobranca_Convenio: faker.lorem.word(),
    ReferenciaCobranca_Convenio: faker.lorem.word(),
    CodigoAreaTel1_Convenio: faker.lorem.word(),
    Telefone1_Convenio: faker.lorem.word(),
    CodigoAreaTel2_Convenio: faker.lorem.word(),
    Telefone2_Convenio: faker.lorem.word(),
    CodigoAreaTel3_Convenio: faker.lorem.word(),
    Telefone3_Convenio: faker.lorem.word(),
    NumeroConta_Convenio: faker.lorem.word(),
    NomeConta_Convenio: faker.lorem.word(),
    DigitoConta_Convenio: faker.lorem.word(),
    AgenciaInstFinan_Convenio: faker.lorem.word(),
    DigitoAgenciaInstFinan_Convenio: faker.lorem.word(),
    CodigoLegado_Convenio: faker.lorem.word(),
    CodigoInterno_Convenio: faker.randomGenerator.integer(100),
    CodigoInterno_GrupoFinanReceita: faker.randomGenerator.integer(100),
    CodigoInterno_CategFinanReceita: faker.randomGenerator.integer(100),
    CodigoInterno_SubCategFinanReceita: faker.randomGenerator.integer(100),
    CodigoInterno_InstFinan: faker.randomGenerator.integer(100),
    FlagCodigoPersonalizado_Convenio: faker.randomGenerator.integer(100),
    FlagObrigaMatriculaConvd_Convenio: faker.randomGenerator.integer(100),
    FlagPermCompraAdicional_Convenio: faker.randomGenerator.integer(100),
    FlagEnderecoContemNum_Convenio: faker.randomGenerator.integer(100),
    FlagEnderecoContemNumEntrega_Convenio: faker.randomGenerator.integer(100),
    FlagEnderecoContemNumCobranca_Convenio: faker.randomGenerator.integer(100),
  );

  static ExpeditionDocumentEntity makeExpeditionDocumentEntity() =>
      ExpeditionDocumentEntity(
        EnterpriseCode: faker.randomGenerator.integer(100),
        ExpeditionControlCode: faker.randomGenerator.integer(100),
        OriginCode: faker.randomGenerator.integer(100),
        OriginType: faker.randomGenerator.integer(100),
        StepCode: faker.randomGenerator.integer(100),
        DocumentNumber: faker.randomGenerator.integer(100).toString(),
        StepName: faker.lorem.word(),
        OriginTypeString: faker.lorem.word(),
      );

  static ExpeditionProductEntity makeExpeditionProductEntity({
    double? quantity,
    int? productPackingCode,
  }) => ExpeditionProductEntity(
    EnterpriseCode: faker.randomGenerator.integer(100),
    ProductCode: faker.randomGenerator.integer(100),
    ProductPackingCode:
        productPackingCode ?? faker.randomGenerator.integer(100),
    Quantity: quantity ?? faker.randomGenerator.decimal(),
    PriceLookUp: faker.lorem.word(),
    Name: faker.food.dish(),
    Packing: faker.lorem.word(),
  );

  static InventoryEntity makeInventoryEntity() => InventoryEntity(
    frozenProcesses: [
      makeFrozenProcessEntity(),
      makeFrozenProcessEntity(),
      makeFrozenProcessEntity(),
    ],
    countings: [
      makeCountingEntity(),
      makeCountingEntity(),
      makeCountingEntity(),
    ],
  );

  static FrozenProcessEntity makeFrozenProcessEntity() => FrozenProcessEntity(
    CataCriacaoInventario: faker.date.dateTime(),
    DataCongelamentoInventario: faker.date.dateTime(),
    CodigoInternoInventario: faker.randomGenerator.integer(100),
    CodigoInternoEmpresa: faker.randomGenerator.integer(100),
    NomeTipoEstoque: faker.lorem.word(),
    ObsInventario: faker.lorem.sentence(),
    NomeFuncionario: faker.person.name(),
    NomeEmpresa: faker.company.name(),
    CodigoEmpresa: faker.randomGenerator.integer(100).toString(),
  );

  static CountingEntity makeCountingEntity() => CountingEntity(
    CodigoInternoInvCont: faker.randomGenerator.integer(100),
    FlagTipoContagemInvCont: faker.randomGenerator.integer(100),
    CodigoInternoInventario: faker.randomGenerator.integer(100),
    NumeroContagemInvCont: faker.randomGenerator.integer(100),
    ObsInvCont: faker.lorem.word(),
  );

  static BuyerEntity makeBuyerEntity() => BuyerEntity(
    Code: faker.randomGenerator.integer(100),
    PersonalizedCode: faker.randomGenerator.integer(100).toString(),
    Name: faker.person.name(),
    NameReduced: faker.person.name(),
    CpfNumber: faker.guid.guid(),
    RgNumber: faker.guid.guid(),
    Seller: faker.randomGenerator.boolean(),
    Buyer: faker.randomGenerator.boolean(),
  );

  static RequestTypeEntity makeRequestTypeEntity({
    int? Code,
    bool? AllowAlterCostOrSalePrice,
  }) => RequestTypeEntity(
    Code: Code ?? faker.randomGenerator.integer(100),
    OperationType: faker.randomGenerator.integer(100),
    UseWholePrice: faker.randomGenerator.integer(1, min: 0),
    UnitValueType: faker.randomGenerator.integer(100),
    TransferUnitValueType: faker.randomGenerator.integer(100),
    PersonalizedCode: faker.randomGenerator.integer(100).toString(),
    Name: faker.person.name(),
    OperationTypeString: faker.lorem.word(),
    UseWholePriceString: faker.randomGenerator.integer(1, min: 0).toString(),
    UnitValueTypeString: faker.randomGenerator.integer(100).toString(),
    TransferUnitValueTypeString: faker.randomGenerator.integer(100).toString(),
    AllowAlterCostOrSalePrice:
        AllowAlterCostOrSalePrice ?? faker.randomGenerator.boolean(),
    AllowDiscount: faker.randomGenerator.boolean(),
  );

  static SupplierEntity makeSupplierEntity({int? Code}) => SupplierEntity(
    Code: Code ?? faker.randomGenerator.integer(100),
    Name: faker.person.name(),
    FantasizesName: faker.company.name(),
    CnpjCpfNumber: faker.randomGenerator.integer(100).toString(),
    InscriptionRgNumber: faker.randomGenerator.integer(100).toString(),
    SupplierType: faker.lorem.word(),
    SupplierRegimeType: faker.lorem.word(),
    Date: faker.date.dateTime().toString(),
    Emails: [
      faker.internet.email(),
      faker.internet.email(),
      faker.internet.email(),
    ],
    Telephones: [
      faker.phoneNumber.us(),
      faker.phoneNumber.us(),
      faker.phoneNumber.us(),
    ],
    Addresses: [
      faker.address.streetAddress(),
      faker.address.streetAddress(),
      faker.address.streetAddress(),
    ],
  );

  static PendingBuyRequestEntity makePendingBuyRequestEntity({
    SupplierEntity? selectedSupplier,
  }) {
    final enterpriseCode = faker.randomGenerator.integer(100);
    final productPackingCode = faker.randomGenerator.integer(100);

    return PendingBuyRequestEntity(
      selectedRequestType: makeBSFRequestTypeEntity(),
      selectedBuyer: makeBuyerEntity(),
      selectedSupplier: selectedSupplier ?? makeSupplierEntity(),
      lastSavedRequestNumber: faker.lorem.word(),
      products: {
        ProductKey(
          enterpriseCode: enterpriseCode,
          productPackingCode: productPackingCode,
        ): BuyRequestProductItemEntity(
          product: ProductModel.fromEntity(
            makeProductEntity(
              productPackingCode: productPackingCode,
              enterpriseCode: enterpriseCode,
            ),
          ).toEntity(),
          quantity: faker.randomGenerator.decimal(),
          cost: faker.randomGenerator.decimal(),
        ),
      },
      selectedEnterprises:
          [
                makeEnterpriseEntity(),
                makeEnterpriseEntity(),
                makeEnterpriseEntity(),
              ]
              .map((e) => SoapEnterpriseByFiltersModel.fromEntity(e).toEntity())
              .toList(),
    );
  }

  static BuyRequestProductItemEntity makeBuyRequestProductItemEntity({
    int? enterpriseCode,
  }) => BuyRequestProductItemEntity(
    product: makeProductEntity(enterpriseCode: enterpriseCode),
    quantity: faker.randomGenerator.decimal(),
    cost: faker.randomGenerator.decimal(),
  );

  static SaleRequestEntity makeSaleRequestEntity({
    SoapCustomerEntity? customer,
  }) => SaleRequestEntity(
    cart: {
      faker.randomGenerator.integer(100): EntityFactory.makeCartProductEntity(),
      faker.randomGenerator.integer(100): EntityFactory.makeCartProductEntity(),
      faker.randomGenerator.integer(100): EntityFactory.makeCartProductEntity(),
    },
    customer: customer ?? makeCustomerEntity(),
    covenant: makeCustomerCovenantEntity(),
    observations: faker.lorem.sentence(),
    instructions: faker.lorem.sentence(),
    needProcessCart: faker.randomGenerator.boolean(),
    Address: makeAddressEntity(),
    DateHourOfCreation: faker.date.dateTime(),
    Delivery: makeDeliveryEntity(),
    DiscountValue: faker.randomGenerator.decimal(),
    EnterpriseId: faker.randomGenerator.integer(100),
    Id: faker.randomGenerator.integer(100),
    Payments: [
      makeFinalizationEntity(),
      makeFinalizationEntity(),
      makeFinalizationEntity(),
    ],
    RequestType: makeSaleRequestRequestTypeEntity(),
    SaleRequestNumber: faker.randomGenerator.numberOfLength(12),
    Seller: makeSellerEntity(),
    TotalLiquid: faker.randomGenerator.decimal() * 100,
  );

  static SellerEntity makeSellerEntity() => SellerEntity(
    Id: faker.randomGenerator.integer(10),
    Name: faker.lorem.word(),
  );

  static DeliveryEntity makeDeliveryEntity() => DeliveryEntity(
    Transporter: faker.company.name(),
    TotalValue: faker.randomGenerator.decimal(),
    DeliveryAddress: makeAddressEntity(),
  );

  static FinalizationEntity makeFinalizationEntity() => FinalizationEntity(
    Id: faker.randomGenerator.integer(100).toString(),
    Name: faker.lorem.word(),
    TotalValue: faker.randomGenerator.decimal(),
    PortionQuantity: faker.randomGenerator.integer(100),
  );

  static SaleRequestRequestTypeEntity makeSaleRequestRequestTypeEntity() =>
      SaleRequestRequestTypeEntity(
        Id: faker.randomGenerator.integer(100),
        PersonalizedCode: faker.randomGenerator.numberOfLength(12),
        Name: faker.lorem.word(),
      );
  static SaleRequestCartProductEntity makeCartProductEntity({
    int? productPackingCode,
    PercentageOrValue? discountType,
    double? MinimumWholeQuantity,
    double? Quantity,
    double? Value,
    double? DiscountValue,
  }) {
    final bool isPercentage = faker.randomGenerator.boolean();
    final percentageOrValue = isPercentage
        ? PercentageOrValue.percentage
        : PercentageOrValue.reais;
    final defaultValue = faker.randomGenerator.decimal() * 100;

    return SaleRequestCartProductEntity(
      ProductPackingCode:
          productPackingCode ?? faker.randomGenerator.integer(100),
      Quantity: Quantity ?? faker.randomGenerator.decimal(),
      Value: Value ?? defaultValue,
      TotalLiquid: faker.randomGenerator.decimal(),
      IncrementPercentageOrValue: percentageOrValue,
      IncrementValue: faker.randomGenerator.decimal(),
      DiscountPercentageOrValue: discountType ?? percentageOrValue,
      DiscountValue: faker.randomGenerator.decimal(),
      DiscountDescription: faker.lorem.word(),
      AutomaticDiscountPercentageOrValue: percentageOrValue,
      AutomaticDiscountValue: faker.randomGenerator.decimal(),
      ExpectedDeliveryDate: faker.date.dateTime(),
      Observations: faker.lorem.word(),
      product: ProductModel.fromEntity(
        makeProductEntity(
          MinimumWholeQuantity: MinimumWholeQuantity,
          RetailPracticedPrice: defaultValue,
        ),
      ).toEntity(),
    );
  }

  static ProcessedCartEntity makeProcessedCartEntity({
    List<SaleRequestCartProductEntity>? products,
  }) => ProcessedCartEntity(
    crossId: faker.guid.guid(),
    EnterpriseCode: faker.randomGenerator.integer(100),
    RequestTypeCode: faker.randomGenerator.integer(100),
    SellerCode: faker.randomGenerator.integer(100),
    CovenantCode: faker.randomGenerator.integer(100),
    CustomerCode: faker.randomGenerator.integer(100),
    Instructions: faker.lorem.sentence(),
    Observations: faker.lorem.sentence(),
    Products:
        products ??
        [
          makeCartProductEntity(),
          makeCartProductEntity(),
          makeCartProductEntity(),
        ],
  );

  static LastSavedSaleRequestEntity makeLastSavedSaleRequestEntity() =>
      LastSavedSaleRequestEntity(
        saleRequestNumber: faker.lorem.word(),
        saleRequestEntity: makeSaleRequestEntity(),
      );

  static ResearchEntity makeResearchEntity() => ResearchEntity(
    EnterpriseCode: faker.randomGenerator.integer(100),
    EnterpriseName: faker.company.name(),
    Code: faker.randomGenerator.integer(100),
    CreationDate: DateTime.now(),
    Observation: faker.lorem.sentence(),
    Name: faker.lorem.word(),
    RestrictProducts: faker.randomGenerator.boolean(),
    IsAssociatingConcurrents: faker.randomGenerator.boolean(),
    Concurrents: [
      makeConcurrentEntity(),
      makeConcurrentEntity(),
      makeConcurrentEntity(),
    ],
    Products: [makeProductEntity(), makeProductEntity(), makeProductEntity()],
  );
  static ConcurrentEntity makeConcurrentEntity() => ConcurrentEntity(
    ConcurrentCode: faker.randomGenerator.integer(100),
    Name: faker.company.name(),
    Observation: faker.lorem.sentence(),
    Address: makeAddressEntity(),
  );

  static ReportScheduleEntity makeReportScheduleEntity({int? Code}) =>
      ReportScheduleEntity(
        Name: faker.lorem.word(),
        Type: faker.lorem.word(),
        CategoryName: faker.lorem.word(),
        SubCategoryName: faker.lorem.word(),
        ReportName: faker.lorem.word(),
        ReportModelName: faker.lorem.word(),
        IsExecuting: faker.randomGenerator.boolean(),
        ExecutionStatus: faker.randomGenerator.boolean(),
        LastExecutionContainsData: faker.randomGenerator.boolean(),
        Code: Code ?? faker.randomGenerator.integer(100),
        CategoryCode: faker.randomGenerator.integer(100),
        SubCategoryCode: faker.randomGenerator.integer(100),
        ReportCode: faker.randomGenerator.integer(100),
        ReportModelCode: faker.randomGenerator.integer(100),
        LastExecutionDate: faker.date.dateTime(),
        LastExecutionStartDateTime: faker.date.dateTime(),
      );

  static ScheduleExecutionsEntity makeScheduleExecutionsEntity({
    int? reportScheduleCode,
    DownloadType? downloadType,
  }) => ScheduleExecutionsEntity(
    ReportScheduleCode:
        reportScheduleCode ?? faker.randomGenerator.integer(100),
    LastExecutionStatus: faker.lorem.word(),
    Executions: [
      makeExecutionsEntity(downloadType: downloadType),
      makeExecutionsEntity(downloadType: downloadType),
      makeExecutionsEntity(downloadType: downloadType),
    ],
  );

  static ExecutionsEntity makeExecutionsEntity({DownloadType? downloadType}) =>
      ExecutionsEntity(
        ExecutionDate: faker.date.dateTime(),
        Attachments: [
          makeAttachmentsEntity(downloadType: downloadType),
          makeAttachmentsEntity(downloadType: downloadType),
          makeAttachmentsEntity(downloadType: downloadType),
        ],
        ContainsData: faker.randomGenerator.boolean(),
      );

  static AttachmentsEntity makeAttachmentsEntity({
    DownloadType? downloadType,
  }) => AttachmentsEntity(
    FileExtension: downloadType?.name ?? faker.lorem.word(),
    AttachmentBase64: Uint8List(faker.randomGenerator.integer(100)),
  );

  static ReceiptEntity makeReceiptEntity({int? CodigoInterno_ProcRecebDoc}) =>
      ReceiptEntity(
        CodigoInterno_ProcRecebDoc:
            CodigoInterno_ProcRecebDoc ?? faker.randomGenerator.integer(100),
        CodigoInterno_Empresa: faker.randomGenerator.integer(100),
        Numero_ProcRecebDoc: faker.randomGenerator.integer(100),
        EmitterName: faker.company.name(),
        Grupo: faker.company.name(),
        Observacoes_ProcRecebDoc: faker.lorem.sentence(),
        DefaultObservations: faker.lorem.sentence(),
        status:
            Status.values[faker.randomGenerator.integer(Status.values.length)],
      );

  static GetProductsJsonParams makeGetProductsJsonParams() =>
      GetProductsJsonParams(
        enterpriseCodes: [
          faker.randomGenerator.integer(100),
          faker.randomGenerator.integer(200, min: 101),
          faker.randomGenerator.integer(300, min: 201),
        ],
        routine: BsRoutine
            .values[faker.randomGenerator.integer(BsRoutine.values.length)],
        searchValue: faker.lorem.word(),
        lastBuyEntranceQuantity: faker.randomGenerator.integer(100),
        buyRequestParams: BuyRequestParams(
          requestTypeCode: faker.randomGenerator.integer(100),
          supplierCode: faker.randomGenerator.integer(100),
        ),
        competingPricesParams: CompetingPricesParams(
          ResearchOfPriceCode: faker.randomGenerator.integer(100),
          ConcurrentCode: faker.randomGenerator.integer(100),
          OnlyAssociated: faker.randomGenerator.boolean(),
          searchType:
              SearchProductCompetingPriceType.values[faker.randomGenerator
                  .integer(SearchProductCompetingPriceType.values.length)],
        ),
      );

  static ProductNotFoundEntity makeProductNotFoundEntity() =>
      ProductNotFoundEntity(
        internalCode: faker.randomGenerator.integer(100),
        quantity: faker.randomGenerator.decimal(),
        ean: faker.randomGenerator.integer(100).toString(),
        observations: faker.lorem.word(),
      );

  static BuyQuotationEntity makeBuyQuotationEntity({
    DateTime? dateOfLimit,
    DateTime? dateOfCreation,
  }) {
    final enterpriseCodes = [
      faker.randomGenerator.integer(100),
      faker.randomGenerator.integer(200, min: 101),
      faker.randomGenerator.integer(300, min: 201),
    ];
    return BuyQuotationEntity(
      Code: faker.randomGenerator.integer(100),
      DateOfCreation: dateOfCreation ?? faker.date.dateTime(),
      DateOfLimit: dateOfLimit ?? faker.date.dateTime(),
      PersonalizedCode: faker.randomGenerator.integer(100).toString(),
      Observations: faker.lorem.sentence(),
      Buyer: makeBuyerEntity(),
      Enterprises: [
        makeBuyQuotationEnterpriseEntity(enterpriseCode: enterpriseCodes[0]),
        makeBuyQuotationEnterpriseEntity(enterpriseCode: enterpriseCodes[1]),
        makeBuyQuotationEnterpriseEntity(enterpriseCode: enterpriseCodes[2]),
      ],
      Products: [
        _makeBuyQuotationProductsEntity(
          productPackingCode: faker.randomGenerator.integer(100),
          enterpriseCodes: enterpriseCodes,
        ),
        _makeBuyQuotationProductsEntity(
          productPackingCode: faker.randomGenerator.integer(200, min: 101),
          enterpriseCodes: enterpriseCodes,
        ),
        _makeBuyQuotationProductsEntity(
          productPackingCode: faker.randomGenerator.integer(300, min: 201),
          enterpriseCodes: enterpriseCodes,
        ),
      ],
    );
  }

  static BuyQuotationEnterpriseEntity makeBuyQuotationEnterpriseEntity({
    int? enterpriseCode,
  }) => BuyQuotationEnterpriseEntity(
    Code: faker.randomGenerator.integer(100),
    isSelected: true,
    enterprise: BuyQuotationEnterpriseInfoEntity(
      PersonalizedCode: faker.randomGenerator.integer(100).toString(),
      Code: enterpriseCode ?? faker.randomGenerator.integer(100),
      Name: faker.company.name(),
      CnpjNumber: faker.randomGenerator.numberOfLength(14),
      InscriptionNumber: faker.randomGenerator.numberOfLength(14),
    ),
  );

  static BuyQuotationProductsEntity _makeBuyQuotationProductsEntity({
    int? productPackingCode,
    List<int>? enterpriseCodes,
  }) => BuyQuotationProductsEntity(
    Code: faker.randomGenerator.integer(100),
    Product: makeProductEntity(productPackingCode: productPackingCode),
    ProductEnterprises: [
      _makeBuyQuotationProductEnterpriseEntity(
        enterpriseCode: enterpriseCodes?[0],
      ),
      _makeBuyQuotationProductEnterpriseEntity(
        enterpriseCode: enterpriseCodes?[1],
      ),
      _makeBuyQuotationProductEnterpriseEntity(
        enterpriseCode: enterpriseCodes?[2],
      ),
    ],
  );

  static BuyQuotationProductEnterpriseEntity
  _makeBuyQuotationProductEnterpriseEntity({int? enterpriseCode}) =>
      BuyQuotationProductEnterpriseEntity(
        Code: faker.randomGenerator.integer(100),
        EnterpriseCode: enterpriseCode ?? faker.randomGenerator.integer(100),
        Quantity: faker.randomGenerator.decimal(),
      );

  static AdjustPriceUIModel makeAdjustPriceUIModel({
    SaleType? selectedSaleType,
    PriceType? selectedPriceType,
    bool? isSelectedClass,
    bool? isSelectedGrid,
    bool? isSelectedOperationalGrouping,
    bool? isSelectedPackings,
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
    Set<ReplicationTypes>? selectedReplications,
    List<ReplicationTypes>? availableReplications,
  }) => AdjustPriceUIModel(
    selectedSaleType:
        selectedSaleType ??
        SaleType.values[faker.randomGenerator.integer(SaleType.values.length)],
    selectedPriceType:
        selectedPriceType ??
        PriceType.values[faker.randomGenerator.integer(
          PriceType.values.length,
        )],
    isSelectedClass: isSelectedClass ?? faker.randomGenerator.boolean(),
    isSelectedGrid: isSelectedGrid ?? faker.randomGenerator.boolean(),
    isSelectedOperationalGrouping:
        isSelectedOperationalGrouping ?? faker.randomGenerator.boolean(),
    isSelectedPackings: isSelectedClass ?? faker.randomGenerator.boolean(),
    selectedStartDate: selectedStartDate ?? faker.date.dateTime(),
    selectedEndDate: selectedEndDate,
    selectedReplications: selectedReplications ?? {},
    availableReplications: availableReplications ?? [],
  );

  static AppUsageEntity makeAppUsageEntity() => AppUsageEntity(
    userName: faker.person.name(),
    enterpriseId: faker.randomGenerator.integer(100),
    usageType: UsageType
        .values[faker.randomGenerator.integer(UsageType.values.length)],
    requestCount: faker.randomGenerator.integer(100),
    enterpriseName: faker.company.name(),
  );

  static EcRequestParams makeEcRequestParams({
    String? workingUrl,
    String? user,
    String? accessKey,
  }) => EcRequestParams(
    workingUrl: workingUrl ?? faker.internet.httpsUrl(),
    user: user ?? faker.internet.userName(),
    accessKey: accessKey ?? faker.guid.guid(),
    actualPage: faker.randomGenerator.integer(100),
    recordsByPage: faker.randomGenerator.integer(100),
  );

  static BSFSaleRequestEntity makeBSFSaleRequestEntity() =>
      BSFSaleRequestEntity(
        code: faker.randomGenerator.integer(100),
        dateOfEmission: faker.date.dateTime(),
        dateOfDelivery: faker.date.dateTime(),
        dateOfExpiration: faker.date.dateTime(),
        dateOfExclusion: faker.date.dateTime(),
        personalizedCode: faker.randomGenerator.numberOfLength(12),
        instructions: faker.lorem.sentence(),
        observations: faker.lorem.sentence(),
        financials: [
          _makeBSFFinancialEntity(),
          _makeBSFFinancialEntity(),
          _makeBSFFinancialEntity(),
        ],
        requestType: BSFRequestTypeEntity(
          code: faker.randomGenerator.integer(100),
          description: faker.lorem.sentence(),
          name: faker.lorem.word(),
          personalizedCode: faker.randomGenerator.integer(100).toString(),
          allowFinancialDiscount: faker.randomGenerator.boolean(),
          allowFinancialIncrement: faker.randomGenerator.boolean(),
          observationsOnPrint: faker.lorem.sentence(),
          type: faker.randomGenerator.integer(100),
          operationType:
              OperationType.values[faker.randomGenerator.integer(
                OperationType.values.length,
              )],
          generatePendencyFinancialTitle: faker.randomGenerator.boolean(),
          allowAlterCostOrSalePrice: faker.randomGenerator.boolean(),
          utilizeSaleLikePdvModel: faker.randomGenerator.boolean(),
          insertProductAutomatically: faker.randomGenerator.boolean(),
          allowsQuantityLikeProduct: faker.randomGenerator.boolean(),
          groupProductsInSaleRequest: faker.randomGenerator.boolean(),
          decimalPlacesForUnitValue: faker.randomGenerator.integer(100),
          decimalPlacesForProductQuantity: faker.randomGenerator.integer(100),
          allowUseDeliveryTax: faker.randomGenerator.boolean(),
          allowUseIncrement: faker.randomGenerator.boolean(),
          allowUseDiscount: faker.randomGenerator.boolean(),
          allowDistribution: faker.randomGenerator.boolean(),
          allowSaleOffer: faker.randomGenerator.boolean(),
          considerAsStockPendency: faker.randomGenerator.boolean(),
          showStockByClass: faker.randomGenerator.boolean(),
          showStockByExtensibleGroup: faker.randomGenerator.boolean(),
          daysOfValidity: faker.randomGenerator.integer(100),
          userGroups: const {},
          paymentFinalizations: const [],
          requestPrintEditionHeaderImage: const {},
          useWholePrice: faker.randomGenerator.integer(100),
          useECommercePrice: faker.randomGenerator.boolean(),
          unitValueType:
              RequestUnitValueType.values[faker.randomGenerator.integer(
                RequestUnitValueType.values.length,
              )],
        ),
        enterprise: BSFEnterpriseEntity(
          code: faker.randomGenerator.integer(100),
          fiscalType: faker.randomGenerator.integer(100),
          federalSimpleType: faker.randomGenerator.integer(100),
          personalizedCode: faker.randomGenerator.integer(100).toString(),
          nationalSimple: const {},
          accountTreasury: const {},
          cnpjNumber: faker.randomGenerator.numberOfLength(14),
          suframaCode: faker.guid.guid(),
          name: faker.company.name(),
          fantasizesName: faker.company.name(),
          contactName: faker.person.name(),
        ),
        customer: makeBSFCustomerEntity(),
        deliveryAddress: BSFAddressEntity(
          code: faker.randomGenerator.integer(100),
          zip: faker.randomGenerator.numberOfLength(8),
          sash: faker.lorem.word(),
          address: faker.lorem.sentence(),
          number: faker.randomGenerator.integer(100).toString(),
          complement: faker.lorem.sentence(),
          district: faker.address.city(),
          reference: faker.address.neighborhood(),
          mainAddress: faker.randomGenerator.boolean(),
          defaultDeliveryAddress: faker.randomGenerator.boolean(),
          defaultCollectAddress: faker.randomGenerator.boolean(),
          addressContainsNumber: faker.randomGenerator.boolean(),
          addressIsInAreaOfDeliveryRestriction: faker.randomGenerator.boolean(),
          inscriptionNumber: faker.randomGenerator.numberOfLength(14),
          country: BSFCountryEntity(
            name: faker.lorem.word(),
            isExteriorCountry: faker.randomGenerator.boolean(),
            spedCode: faker.randomGenerator.integer(100).toString(),
          ),
          state: BSFStateEntity(
            acronym: faker.lorem.word(),
            description: faker.lorem.word(),
          ),
          addressType: faker.randomGenerator.integer(100),
        ),
        deliveryTax: BSFDeliveryTaxWrapperEntity(
          deliveryTax: _makeBSFValueTypeEntity(),
          mailFreightType: const {},
          isFob: faker.randomGenerator.boolean(),
          isDiscounted: faker.randomGenerator.boolean(),
        ),
        increment: _makeBSFValueTypeEntity(),
        financialIncrement: _makeBSFValueTypeEntity(),
        financialDiscount: _makeBSFValueTypeEntity(),
        totalLiquid: faker.randomGenerator.decimal(),
        expeditionControlCode: faker.randomGenerator.integer(100),
        isOnExpedition: faker.randomGenerator.boolean(),
        freight: BSFFreightEntity(
          value: faker.randomGenerator.decimal(),
          freightValueProrated: faker.randomGenerator.decimal(),
          security: faker.randomGenerator.decimal(),
          discount: _makeBSFValueTypeEntity(),
          increment: _makeBSFValueTypeEntity(),
          type: faker.randomGenerator.integer(100),
          icmsAliquot: faker.randomGenerator.decimal(),
          irrf: faker.randomGenerator.decimal(),
          inss: faker.randomGenerator.decimal(),
          icmsRetainByDestiny: faker.randomGenerator.boolean(),
          code: faker.randomGenerator.integer(100),
          documentNumber: faker.randomGenerator.integer(100),
          documentNumberComplement: faker.lorem.word(),
          eletronicAccessKey: const {},
          dateOfEmission: faker.date.dateTime(),
          dateOfEntrance: faker.date.dateTime(),
        ),
        products: [
          _makeBSFProductItemEntity(),
          _makeBSFProductItemEntity(),
          _makeBSFProductItemEntity(),
        ],
        discounts: const [],
      );

  static BSFCustomerEntity makeBSFCustomerEntity() => BSFCustomerEntity(
    code: faker.randomGenerator.integer(100),
    covenantCode: faker.randomGenerator.integer(100),
    personalizedCode: faker.randomGenerator.integer(100).toString(),
    name: faker.person.name(),
    nameReduced: faker.person.name(),
    cnpjCpfNumber: faker.randomGenerator.numberOfLength(14),
    suframaCode: faker.guid.guid(),
    limitOfPurchase: faker.randomGenerator.decimal(),
    inscriptionRgNumber: faker.guid.guid(),
    paymentFinalizations: List<BSFPaymentFinalizationEntity>.generate(
      3,
      (_) => makeBSFPaymentFinalizationEntity(),
    ),
    paymentConditions: List<BSFPaymentConditionEntity>.generate(
      3,
      (_) => makeBSFPaymentConditionEntity(),
    ),
    saleBlockade: makeBsfSaleBlockadeEntity(),
    saleBlockadeInstruction: makeBsfSaleBlockadeInstructionEntity(),
    covenants: [makeBsfCovenantEntity(), makeBsfCovenantEntity()],
  );

  static BsfSaleBlockadeEntity makeBsfSaleBlockadeEntity() =>
      BsfSaleBlockadeEntity(
        code: faker.randomGenerator.integer(100),
        personalizedCode: faker.randomGenerator.integer(100).toString(),
        legacyCode: faker.lorem.word(),
        description: faker.lorem.sentence(),
        allowSale: faker.randomGenerator.boolean(),
        allowSaleRequest: faker.randomGenerator.boolean(),
        allowSaleWithPaymentFinalizationTypeCheckOrPortion: faker
            .randomGenerator
            .boolean(),
        stringAllowSale: faker.lorem.word(),
        stringAllowSaleRequest: faker.lorem.word(),
        stringAllowSaleWithPaymentFinalizationTypeCheckOrPortion: faker.lorem
            .word(),
      );

  static BsfSaleBlockadeInstructionEntity
  makeBsfSaleBlockadeInstructionEntity() => BsfSaleBlockadeInstructionEntity(
    code: faker.randomGenerator.integer(100),
    personalizedCode: faker.randomGenerator.integer(100).toString(),
    legacyCode: faker.lorem.word(),
    description: faker.lorem.sentence(),
  );

  static BsfCovenantEntity makeBsfCovenantEntity() => BsfCovenantEntity(
    code: faker.randomGenerator.integer(100),
    personalizedCode: faker.randomGenerator.integer(100).toString(),
    legacyCode: faker.lorem.word(),
    name: faker.company.name(),
    fantasyName: faker.company.name(),
    cnpjNumber: faker.randomGenerator.numberOfLength(14),
    formatedCnpjNumber: faker.randomGenerator.numberOfLength(14),
    stateRegistration: faker.randomGenerator.numberOfLength(14),
    formatedStateRegistration: faker.randomGenerator.numberOfLength(14),
    dateOfCadaster: faker.date.dateTime(),
    email: faker.internet.email(),
    dateOfBirthContact: faker.date.dateTime(),
    nameOfContact: faker.person.name(),
    haveObservations: faker.randomGenerator.boolean(),
    requiredConveneMatriculate: faker.randomGenerator.boolean(),
    allowSaleAdditional: faker.randomGenerator.boolean(),
    address: null,
    deliveryAddress: null,
    collectAddress: null,
    saleBlockade: makeBsfSaleBlockadeEntity(),
    saleBlockadeInstruction: makeBsfSaleBlockadeInstructionEntity(),
  );

  static BSFFinancialEntity _makeBSFFinancialEntity() => BSFFinancialEntity(
    paymentFinalizations: [
      _makeBSFPaymentFinalizationWrapperEntity(),
      _makeBSFPaymentFinalizationWrapperEntity(),
      _makeBSFPaymentFinalizationWrapperEntity(),
    ],
    paybackValue: faker.randomGenerator.decimal(),
  );

  static BSFPaymentFinalizationWrapperEntity
  _makeBSFPaymentFinalizationWrapperEntity() =>
      BSFPaymentFinalizationWrapperEntity(
        paymentFinalization: _makeBSFPaymentFinalizationEntity(),
        value: faker.randomGenerator.decimal(),
        financialIncrement: faker.randomGenerator.decimal(),
        financialDiscount: faker.randomGenerator.decimal(),
        quantityOfPortions: faker.randomGenerator.integer(100),
        tefSequencialUniqueNumber: faker.guid.guid(),
        tefAutorizationCreditCode: faker.guid.guid(),
        devolutionCreditCode: faker.randomGenerator.numberOfLength(4),
        identificationCode: faker.randomGenerator.numberOfLength(4),
        paymentCondition: makeBSFPaymentConditionEntity(),
        creditCardNumber: faker.randomGenerator.numberOfLength(16),
        creditCardValidate: faker.date.dateTime(),
        portions: const [],
        userAuthorization: _makeBSFUserAuthorizationEntity(),
      );

  static BSFPaymentFinalizationEntity _makeBSFPaymentFinalizationEntity() =>
      BSFPaymentFinalizationEntity(
        paymentForm: _makeBSFPaymentFormEntity(),
        Description: faker.lorem.word(),
        code: faker.randomGenerator.integer(100),
        isDeactivate: faker.randomGenerator.boolean(),
        isDeactivateString: faker.lorem.word(),
        actionCheckType: ActionCheckType.values.elementAt(
          faker.randomGenerator.integer(ActionCheckType.values.length),
        ),
        cardTerminalType: CardTerminalType.values.elementAt(
          faker.randomGenerator.integer(CardTerminalType.values.length),
        ),
        planCode: faker.lorem.word(),
        financialTax: faker.randomGenerator.decimal(),
        identificationCode: faker.lorem.word(),
        identificationTefFlagCode: faker.lorem.word(),
        action: makeBSFPaymentActionEntity(),
      );

  static BSFPaymentActionEntity makeBSFPaymentActionEntity() =>
      BSFPaymentActionEntity(
        code: faker.randomGenerator.integer(100),
        allowsCheck: faker.randomGenerator.boolean(),
        allowsAdministrator: faker.randomGenerator.boolean(),
        allowsCardTerminalType: faker.randomGenerator.boolean(),
        name: faker.lorem.word(),
        description: faker.lorem.word(),
        type:
            PaymentFinalizationActionType.values[faker.randomGenerator.integer(
              PaymentFinalizationActionType.values.length,
            )],
        allowsSaleWithEntrance: faker.randomGenerator.boolean(),
        allowsPaymentConditions: faker.randomGenerator.boolean(),
        allowsEletronicCheckPredated: faker.randomGenerator.boolean(),
      );

  static BSFPaymentFormEntity _makeBSFPaymentFormEntity() =>
      BSFPaymentFormEntity(
        type: PaymentFormType.values.elementAt(
          faker.randomGenerator.integer(PaymentFormType.values.length),
        ),
        reducedName: faker.lorem.word(),
        name: faker.lorem.word(),
      );

  static BSFUserAuthorizationEntity _makeBSFUserAuthorizationEntity() =>
      BSFUserAuthorizationEntity(identification: faker.lorem.word());

  static BSFValueTypeEntity _makeBSFValueTypeEntity() => BSFValueTypeEntity(
    type: PercentageOrValue.values.elementAt(
      faker.randomGenerator.integer(PercentageOrValue.values.length),
    ),
    value: faker.randomGenerator.decimal(),
  );

  static BSFIcmsEntity _makeBSFIcmsEntity() => BSFIcmsEntity(
    taxOnState: faker.randomGenerator.decimal(),
    haveCovenantBetweenStates: faker.randomGenerator.boolean(),
    utilizeIVASTAdjusted: faker.randomGenerator.boolean(),
    simplifiedEstimationScheme: faker.randomGenerator.boolean(),
    reductionMargin: faker.randomGenerator.decimal(),
    iVAMargin: faker.randomGenerator.decimal(),
    reductionIVAMarginForFederalSimple: faker.randomGenerator.decimal(),
    aliquot: faker.randomGenerator.decimal(),
    aditionalIcmsAliquotFEM: faker.randomGenerator.decimal(),
    stave: faker.randomGenerator.decimal(),
    taxeAliquotNational: faker.randomGenerator.decimal(),
    taxeAliquotImport: faker.randomGenerator.decimal(),
    taxeAliquotState: faker.randomGenerator.decimal(),
    taxeAliquotMunicipal: faker.randomGenerator.decimal(),
    taxeAliquotFederal: faker.randomGenerator.decimal(),
    reductionType: faker.randomGenerator.integer(100),
    allowReductionMargin: faker.randomGenerator.boolean(),
    allowIVAMargin: faker.randomGenerator.boolean(),
    allowIcmsAliquot: faker.randomGenerator.boolean(),
    reductionMarginIsRequired: faker.randomGenerator.boolean(),
    icmsAliquotIsRequired: faker.randomGenerator.boolean(),
    isValidReductionMargin: faker.randomGenerator.boolean(),
    isValidIVAMargin: faker.randomGenerator.boolean(),
    isValidIcmsAliquot: faker.randomGenerator.boolean(),
    isValidAditionalIcmsAliquotFEM: faker.randomGenerator.boolean(),
    isValidReductionType: faker.randomGenerator.boolean(),
    containsFiscalAdjuste: faker.randomGenerator.boolean(),
    isValidFiscalAdjuste: faker.randomGenerator.boolean(),
    isImporter: faker.randomGenerator.boolean(),
    isImporterAcquiredDomestic: faker.randomGenerator.boolean(),
    originalAliquot: faker.randomGenerator.decimal(),
    fiscalAdjustCode: faker.randomGenerator.integer(100).toString(),
    fiscalBenefitCode: faker.randomGenerator.integer(100).toString(),
    tributarySituation: _makeBSFTributarySituationEntity(),
    fiscalObservation: faker.lorem.word(),
    fiscalAdjustObservation: faker.lorem.word(),
    stateInternalIcms: faker.randomGenerator.decimal(),
  );

  static BSFIpiEntity _makeBSFIpiEntity() => BSFIpiEntity(
    aliquot: faker.randomGenerator.decimal(),
    type: faker.randomGenerator.integer(100),
    tributarySituation: faker.lorem.word(),
    fiscalObservation: faker.lorem.word(),
    isValid: faker.randomGenerator.boolean(),
  );

  static BSFTributarySituationEntity _makeBSFTributarySituationEntity() =>
      BSFTributarySituationEntity(
        code: faker.randomGenerator.integer(100).toString(),
        description: faker.lorem.word(),
        codeCSOSN: faker.randomGenerator.integer(100).toString(),
        fiscalBenefitCodeStatesRequired: faker.randomGenerator
            .boolean()
            .toString(),
        isImported: faker.randomGenerator.boolean(),
        isSubstitution: faker.randomGenerator.boolean(),
        originType: faker.randomGenerator.integer(100),
        tributation: faker.randomGenerator.integer(100),
      );

  static BSFProductItemEntity _makeBSFProductItemEntity() =>
      BSFProductItemEntity(
        productPackingCode: faker.randomGenerator.integer(100),
        code: faker.randomGenerator.integer(100),
        icms: _makeBSFIcmsEntity(),
        ipi: _makeBSFIpiEntity(),
        product: BSFProductDetailsEntity(
          name: faker.food.dish(),
          code: faker.randomGenerator.integer(100),
          complement: faker.lorem.word(),
          consolidateGrateChildsInFiscalNote: faker.randomGenerator.boolean(),
          fatherOfGrateIsLiberatedSale: faker.randomGenerator.boolean(),
          isBasicBasketItem: faker.randomGenerator.boolean(),
          isDesativate: faker.randomGenerator.boolean(),
          isFloatingProduct: faker.randomGenerator.boolean(),
          isOutOfLine: faker.randomGenerator.boolean(),
          isPriceControlled: faker.randomGenerator.boolean(),
          isProductForComplementFiscalNote: faker.randomGenerator.boolean(),
          isReturnablePacking: faker.randomGenerator.boolean(),
          isScheduledToUnify: faker.randomGenerator.boolean(),
          practicePriceRoundRules: faker.randomGenerator.boolean(),
          legacyCode: faker.guid.guid(),
          manufacturerString: faker.guid.guid(),
          productPackingEanString: faker.randomGenerator
              .integer(100)
              .toString(),
          productPackingPersonalizedCodeString: faker.randomGenerator
              .integer(100)
              .toString(),
          productPackingQuantityString: faker.randomGenerator
              .integer(100)
              .toString(),
          productPackingSpecificationString: faker.randomGenerator
              .integer(100)
              .toString(),
          productPackingString: faker.randomGenerator.integer(100).toString(),
          isAlcoholicProduct: faker.randomGenerator.boolean(),
          isFatherOfGrate: faker.randomGenerator.boolean(),
          fatherGrateCode: faker.randomGenerator.integer(100),
          images: [
            faker.internet.httpUrl(),
            faker.internet.httpsUrl(),
            faker.internet.httpUrl(),
          ],
          personalizedCode: faker.randomGenerator.integer(100).toString(),
          productPackingTypeString: faker.lorem.word(),
          productPackingQuantity: faker.randomGenerator.decimal(),
          productPackingPriceLookUpString: faker.lorem.word(),
        ),
        fiscalCode: _makeBSFFiscalCodeEntity(),
        compositionChilds: const [],
        eanCode: faker.randomGenerator.numberOfLength(13),
        freight: BSFProductFreightEntity(
          discount: _makeBSFValueTypeEntity(),
          increment: _makeBSFValueTypeEntity(),
          value: faker.randomGenerator.decimal(),
        ),
        discounts: [
          _makeBSFProductDiscountEntity(),
          _makeBSFProductDiscountEntity(),
          _makeBSFProductDiscountEntity(),
        ],
        expectedDeliveryDate: faker.date.dateTime(),
        deliveryTax: _makeBSFValueTypeEntity(),
        increment: _makeBSFValueTypeEntity(),
        creditOnOrigin: _makeBSFValueTypeEntity(),
        compensation: _makeBSFValueTypeEntity(),
        quantity: faker.randomGenerator.decimal(),
        value: faker.randomGenerator.decimal(),
        priceCost: _makeBSFPriceCostEntity(),
      );

  static BSFPriceCostEntity _makeBSFPriceCostEntity() => BSFPriceCostEntity(
    saleRetailPricePractice: faker.randomGenerator.decimal(),
    lastSaleRetailPrice: faker.randomGenerator.decimal(),
    wholeSalePricePractice: faker.randomGenerator.decimal(),
    lastWholeSalePrice: faker.randomGenerator.decimal(),
    eCommercePricePractice: faker.randomGenerator.decimal(),
    lastECommercePrice: faker.randomGenerator.decimal(),
    saleRetailOfferPractice: faker.randomGenerator.decimal(),
    lastSaleRetailOffer: faker.randomGenerator.decimal(),
    wholeSaleOfferPractice: faker.randomGenerator.decimal(),
    lastWholeSaleOffer: faker.randomGenerator.decimal(),
    eCommerceOfferPractice: faker.randomGenerator.decimal(),
    lastECommerceOffer: faker.randomGenerator.decimal(),
    replacementCost: faker.randomGenerator.decimal(),
    lastReplacementCost: faker.randomGenerator.decimal(),
    mediumReplacementCost: faker.randomGenerator.decimal(),
    subsidizedReplacementCost: faker.randomGenerator.decimal(),
    activeSubsidizedReplacementCost: faker.randomGenerator.decimal(),
    liquidCost: faker.randomGenerator.decimal(),
    lastLiquidCost: faker.randomGenerator.decimal(),
    lastUnitValue: faker.randomGenerator.decimal(),
    baseCalcIcmsSubstUnit: faker.randomGenerator.decimal(),
    valueOfIcmsSubstUnit: faker.randomGenerator.decimal(),
    valueOfIcmsOwnerUnit: faker.randomGenerator.decimal(),
    mininumQuantityForWholeSale: faker.randomGenerator.decimal(),
    mediumLiquidCost: faker.randomGenerator.decimal(),
    subsidizedLiquidCost: faker.randomGenerator.decimal(),
    activeSubsidizedLiquidCost: faker.randomGenerator.decimal(),
    fiscalBaseCalcSubstitute: faker.randomGenerator.decimal(),
    fiscalBaseCalcSubstitutePrevious: faker.randomGenerator.decimal(),
    replacementCostReal: faker.randomGenerator.decimal(),
    lastReplacementCostReal: faker.randomGenerator.decimal(),
    liquidCostReal: faker.randomGenerator.decimal(),
    lastLiquidCostReal: faker.randomGenerator.decimal(),
    replacementCostFiscal: faker.randomGenerator.decimal(),
    lastReplacementCostFiscal: faker.randomGenerator.decimal(),
    liquidCostFiscal: faker.randomGenerator.decimal(),
    lastLiquidCostFiscal: faker.randomGenerator.decimal(),
    operationCost: faker.randomGenerator.decimal(),
    bonusSubsidyValue: faker.randomGenerator.decimal(),
    bonusSubsidyActiveValue: faker.randomGenerator.decimal(),
    bonusSubsidyUnitaryValue: faker.randomGenerator.decimal(),
    bonusSubsidyActiveUnitaryValue: faker.randomGenerator.decimal(),
    isOfferInRetail: faker.randomGenerator.boolean(),
    salePracticedTypeInSaleRetail: faker.randomGenerator.integer(5),
    salePracticedInSaleRetail: faker.randomGenerator.decimal(),
    isOfferInWhole: faker.randomGenerator.boolean(),
    salePracticedTypeInWholeSale: faker.randomGenerator.integer(5),
    salePracticedInWholeSale: faker.randomGenerator.decimal(),
    isOfferInECommerce: faker.randomGenerator.boolean(),
    salePriceTypePracticedInECommerce: faker.randomGenerator.integer(5),
    salePracticedInECommerce: faker.randomGenerator.decimal(),
  );

  static BSFFiscalCodeEntity _makeBSFFiscalCodeEntity() => BSFFiscalCodeEntity(
    code: _makeBSFFiscalCodeValueEntity(code: '5405', isValid: true),
    codeCompensation: _makeBSFFiscalCodeValueEntity(code: '', isValid: false),
    description: faker.lorem.sentence(),
    fiscalObservation: faker.randomGenerator.boolean()
        ? faker.lorem.sentence()
        : null,
    codeString: '5405',
    codeCompensationString: '',
    isBonus: faker.randomGenerator.boolean(),
    isSampleFree: faker.randomGenerator.boolean(),
    isRemittanceOfDeliveryFuture: faker.randomGenerator.boolean(),
    isDeliveryFuture: faker.randomGenerator.boolean(),
    isFuel: faker.randomGenerator.boolean(),
    isConsignment: faker.randomGenerator.boolean(),
    isEntranceOfConsignment: faker.randomGenerator.boolean(),
    isSimbolicDevolutionOfConsignment: faker.randomGenerator.boolean(),
    isDevolutionOfConsignment: faker.randomGenerator.boolean(),
    isReceiveOfDeliveryFuture: faker.randomGenerator.boolean(),
    isIndustrialization: faker.randomGenerator.boolean(),
    isNoteByCoupon: faker.randomGenerator.boolean(),
    isTransfer: faker.randomGenerator.boolean(),
    isDevolution: faker.randomGenerator.boolean(),
    isSubstitution: faker.randomGenerator.boolean(),
    isValidFiscalCodeForSubstituteOrNotSubstitute: faker.randomGenerator
        .boolean(),
    isConsumptionOrIngredient: faker.randomGenerator.boolean(),
    isOtherNotSpecified: faker.randomGenerator.boolean(),
    isEntrance: faker.randomGenerator.boolean(),
    isExit: faker.randomGenerator.boolean(),
    isSaleWithSubstituton: faker.randomGenerator.boolean(),
    isTransferWithSubstituton: faker.randomGenerator.boolean(),
    isSaleDevolutionWithSubstituton: faker.randomGenerator.boolean(),
    isBuyDevolutionWithSubstituton: faker.randomGenerator.boolean(),
    allowCreditForPisCofins: faker.randomGenerator.boolean(),
    isConsumerSale: faker.randomGenerator.boolean(),
    isAquisitionForSaleWithPisCofinsCredtRight: faker.randomGenerator.boolean(),
    isAquisitionForUtilizationAsInsummeWithPisCofinsCredtRight: faker
        .randomGenerator
        .boolean(),
    isAquisitionForServiceAsInsummeWithPisCofinsCredtRight: faker
        .randomGenerator
        .boolean(),
    isSaleDevolutionsIncidNotCumulativeWithPisCofinsCredtRight: faker
        .randomGenerator
        .boolean(),
    isOtherOperationsWithPisCofinsCredtRight: faker.randomGenerator.boolean(),
    isFiscalCodeNotTributedForPisCofins: faker.randomGenerator.boolean(),
    isElectricEnergyAquisition: faker.randomGenerator.boolean(),
    isImobilizeAtive: faker.randomGenerator.boolean(),
    isRemittanceThirdpartForAccountOrder: faker.randomGenerator.boolean(),
    isRemittanceToDeposit: faker.randomGenerator.boolean(),
    isRemittanceToExport: faker.randomGenerator.boolean(),
    isComunicationServiceAquisition: faker.randomGenerator.boolean(),
    isService: faker.randomGenerator.boolean(),
    isImportation: faker.randomGenerator.boolean(),
    isExportation: faker.randomGenerator.boolean(),
    isFreightService: faker.randomGenerator.boolean(),
    withoutCreditForICMS: faker.randomGenerator.boolean(),
    isSaleMovementsDailyGobal: faker.randomGenerator.boolean(),
    groupFiscalCodeType: faker.randomGenerator.integer(10),
    isAllowCreditOrDebitForIPI: faker.randomGenerator.boolean(),
    isInterstateSaleForConsumption: faker.randomGenerator.boolean(),
    isInterstateSaleSubstitutionForConsumption: faker.randomGenerator.boolean(),
  );

  static BSFFiscalCodeValueEntity _makeBSFFiscalCodeValueEntity({
    required String code,
    required bool isValid,
  }) => BSFFiscalCodeValueEntity(
    code: code,
    isOldFormat: faker.randomGenerator.boolean(),
    isValid: isValid,
  );

  static BSFDiscountEntity _makeBSFProductDiscountEntity() => BSFDiscountEntity(
    order: faker.randomGenerator.integer(100),
    discountOrigin: faker.randomGenerator.integer(100),
    user: faker.lorem.word(),
    justification: faker.lorem.word(),
    discount: _makeBSFValueTypeEntity(),
  );

  static AdjustCostParametersEntity makeAdjustCostParametersEntity() =>
      AdjustCostParametersEntity(
        ProductCode: faker.randomGenerator.integer(100),
        EnterpriseCode: faker.randomGenerator.integer(100),
        PackingCode: faker.randomGenerator.integer(100),
        UpdateCostClass: faker.randomGenerator.boolean(),
        UpdateChildCost: faker.randomGenerator.boolean(),
        ReplacementCost: faker.randomGenerator.decimal(),
        LiquidCost: faker.randomGenerator.decimal(),
        LastUnitValue: faker.randomGenerator.decimal(),
        BaseCalcIcmsSubstUnit: faker.randomGenerator.decimal(),
        ValueOfIcmsSubstUnit: faker.randomGenerator.decimal(),
        ValueOfIcmsOwnerUnit: faker.randomGenerator.decimal(),
        FiscalBaseCalcSubstitute: faker.randomGenerator.decimal(),
        ReplacementCostReal: faker.randomGenerator.decimal(),
        LiquidCostReal: faker.randomGenerator.decimal(),
        ReplacementCostFiscal: faker.randomGenerator.decimal(),
        LiquidCostFiscal: faker.randomGenerator.decimal(),
        ActualizationType:
            AdjustCostActualizationType.values[faker.randomGenerator.integer(
              AdjustCostActualizationType.values.length,
            )],
        ActualizeDataAfterUpdate: faker.randomGenerator.boolean(),
        UpdateEnterpriseGroup: faker.randomGenerator.boolean(),
      );
  static BSFPaymentFinalizationEntity makeBSFPaymentFinalizationEntity() =>
      BSFPaymentFinalizationEntity(
        paymentForm: _makeBSFPaymentFormEntity(),
        Description: faker.lorem.word(),
        code: faker.randomGenerator.integer(100),
        isDeactivate: faker.randomGenerator.boolean(),
        isDeactivateString: faker.lorem.word(),
        actionCheckType: ActionCheckType.values.elementAt(
          faker.randomGenerator.integer(ActionCheckType.values.length),
        ),
        cardTerminalType: CardTerminalType.values.elementAt(
          faker.randomGenerator.integer(CardTerminalType.values.length),
        ),
        planCode: faker.lorem.word(),
        financialTax: faker.randomGenerator.decimal(),
        identificationCode: faker.lorem.word(),
        identificationTefFlagCode: faker.lorem.word(),
        action: makeBSFPaymentActionEntity(),
      );

  static BSFRequestTypeEntity makeBSFRequestTypeEntity() =>
      BSFRequestTypeEntity(
        code: faker.randomGenerator.integer(1000),
        name: faker.person.name(),
        description: faker.lorem.sentence(),
        observationsOnPrint: faker.lorem.sentence(),
        personalizedCode: faker.randomGenerator.string(10),
        type: faker.randomGenerator.integer(5),
        operationType: OperationType
            .values[faker.randomGenerator.integer(OperationType.values.length)],
        generatePendencyFinancialTitle: faker.randomGenerator.boolean(),
        allowAlterCostOrSalePrice: faker.randomGenerator.boolean(),
        utilizeSaleLikePdvModel: faker.randomGenerator.boolean(),
        insertProductAutomatically: faker.randomGenerator.boolean(),
        allowsQuantityLikeProduct: faker.randomGenerator.boolean(),
        groupProductsInSaleRequest: faker.randomGenerator.boolean(),
        decimalPlacesForUnitValue: faker.randomGenerator.integer(2),
        decimalPlacesForProductQuantity: faker.randomGenerator.integer(2),
        allowUseDeliveryTax: faker.randomGenerator.boolean(),
        allowUseIncrement: faker.randomGenerator.boolean(),
        allowUseDiscount: faker.randomGenerator.boolean(),
        allowDistribution: faker.randomGenerator.boolean(),
        allowSaleOffer: faker.randomGenerator.boolean(),
        considerAsStockPendency: faker.randomGenerator.boolean(),
        showStockByClass: faker.randomGenerator.boolean(),
        showStockByExtensibleGroup: faker.randomGenerator.boolean(),
        daysOfValidity: faker.randomGenerator.integer(30),
        allowFinancialIncrement: faker.randomGenerator.boolean(),
        allowFinancialDiscount: faker.randomGenerator.boolean(),
        userGroups: null,
        paymentFinalizations: const [],
        requestPrintEditionHeaderImage: null,
        useWholePrice: faker.randomGenerator.integer(2),
        useECommercePrice: faker.randomGenerator.boolean(),
        unitValueType:
            RequestUnitValueType.values[faker.randomGenerator.integer(
              RequestUnitValueType.values.length,
            )],
      );

  static EcRequestTypeParametersEntity makeEcRequestTypeParametersEntity() =>
      EcRequestTypeParametersEntity(
        enterpriseCode: faker.randomGenerator.integer(100),
        inclusiveSale: faker.randomGenerator.boolean(),
        inclusiveBuy: faker.randomGenerator.boolean(),
        inclusiveTransfer: faker.randomGenerator.boolean(),
      );

  static BSFDiscountEntity makeBSFDiscountEntity({
    BSFValueTypeEntity? discount,
  }) => BSFDiscountEntity(
    order: faker.randomGenerator.integer(100),
    discountOrigin: faker.randomGenerator.integer(100),
    user: faker.lorem.word(),
    justification: faker.lorem.word(),
    discount: discount ?? _makeBSFValueTypeEntity(),
  );

  static UtilizationParametersEntity makeUtilizationParametersEntity() =>
      UtilizationParametersEntity(
        isShielded: faker.randomGenerator.boolean(),
        baseDate: faker.date.dateTime(),
        valueParcel: faker.randomGenerator.decimal(),
      );

  static PaymentConditionEntity makePaymentConditionEntity() =>
      PaymentConditionEntity(
        isShielded: faker.randomGenerator.boolean(),
        composition: faker.lorem.word(),
        symbolType:
            PaymentConditionSymbolType.values[faker.randomGenerator.integer(
              PaymentConditionSymbolType.values.length,
            )],
        fillType:
            PaymentConditionFillType.values[faker.randomGenerator.integer(
              PaymentConditionFillType.values.length,
            )],
        portionCount: faker.randomGenerator.integer(10),
      );

  static BSFPaymentConditionEntity makeBSFPaymentConditionEntity() =>
      BSFPaymentConditionEntity(
        isShielded: faker.randomGenerator.boolean(),
        code: faker.randomGenerator.integer(100),
        personalizedCode: faker.randomGenerator.integer(100).toString(),
        isFixed: faker.randomGenerator.boolean(),
        fillType:
            PaymentConditionFillType.values[faker.randomGenerator.integer(
              PaymentConditionFillType.values.length,
            )],
        useType:
            PaymentConditionUseType.values[faker.randomGenerator.integer(
              PaymentConditionUseType.values.length,
            )],
        maximumNumberPortions: faker.randomGenerator.integer(12),
        minimumValueInPortions: faker.randomGenerator.decimal(),
        intervalMinimumBetweenPortions: faker.randomGenerator.integer(30),
        intervalMaximumBetweenPortions: faker.randomGenerator.integer(60),
        internalPaymentCondition: faker.randomGenerator.boolean(),
        minimumPercentageOfFirstPortion: faker.randomGenerator.decimal(),
        description: faker.lorem.sentence(),
        smartDescription: faker.lorem.sentence(),
        condition: makePaymentConditionEntity(),
        utilizeParameters: makeUtilizationParametersEntity(),
        isTemporal: faker.randomGenerator.boolean(),
        allowDifferentValues: faker.randomGenerator.boolean(),
        isAtSight: faker.randomGenerator.boolean(),
        isSaleDevolution: faker.randomGenerator.boolean(),
        isReadSale: faker.randomGenerator.boolean(),
        jumpHolidays: faker.randomGenerator.boolean(),
      );

  static CreditCardPropertiesEntity makeCreditCardPropertiesEntity() =>
      CreditCardPropertiesEntity(
        creditCardNumber: faker.randomGenerator.numberOfLength(16),
        creditCardValidate: faker.date.dateTime(),
        quantityOfPortions: faker.randomGenerator.integer(10),
      );
}
