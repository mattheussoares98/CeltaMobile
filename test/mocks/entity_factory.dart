import 'dart:typed_data';

import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_intelligence/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_intelligence/features/buy_request/data/models/models.dart';
import 'package:celta_intelligence/features/buy_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/competing_prices/domain/entities/entities.dart';
import 'package:celta_intelligence/features/customer_register/domain/entities/entities.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_intelligence/features/expedition_conference/domain/entities/entities.dart';
import 'package:celta_intelligence/features/inventory/domain/entities/entities.dart';
import 'package:celta_intelligence/features/receipt/domain/entity/entity.dart';
import 'package:celta_intelligence/features/reports/domain/entities/entities.dart';
import 'package:celta_intelligence/features/sale_request/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static EnterpriseEntity makeEnterpriseEntity({
    int? id,
    String? name,
    int? code,
  }) => EnterpriseEntity(
    id: id ?? faker.randomGenerator.integer(100),
    name: name ?? faker.company.name(),
    baseUrl: faker.internet.httpsUrl(),
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
    EnterpriseParticipateEnterpriseGroup: faker.randomGenerator.boolean(),
    ProductCodeWithCheckerDigit: faker.randomGenerator.boolean(),
    UseEcommerceSale: faker.randomGenerator.boolean(),
    UseRetailSale: faker.randomGenerator.boolean(),
    UseWholeSale: faker.randomGenerator.boolean(),
  );

  static SubEnterpriseEntity makeSubEnterpriseEntity() => SubEnterpriseEntity(
    id: faker.randomGenerator.integer(100),
    personalizedCode: faker.randomGenerator.integer(100).toString(),
    name: faker.company.name(),
    cnpjNumber: faker.randomGenerator.integer(14, min: 14).toString(),
  );

  static UserEntity makeUserEntity() => UserEntity(
    name: faker.person.name(),
    enterpriseName: faker.company.name(),
    AccessKey: faker.guid.guid(),
    CrossIdentity_Usuario: faker.guid.guid(),
  );

  static EnterprisePermissionEntity makeEnterprisePermissionEntity() =>
      EnterprisePermissionEntity(
        id: faker.randomGenerator.integer(100),
        name: faker.company.name(),
        baseUrl: faker.internet.httpsUrl(),
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
  }) => ProductEntity(
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
    StorageAreaAddress: faker.guid.guid(),
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
    AlterationPriceForAllPackings: faker.randomGenerator.boolean(),
    IsFatherOfGrate: faker.randomGenerator.boolean(),
    IsChildOfGrate: faker.randomGenerator.boolean(),
    InClass: faker.randomGenerator.boolean(),
    MarkUpdateClassInAdjustSalePriceIndividual: faker.randomGenerator.boolean(),
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
    StorageAreaAddress: faker.guid.guid(),
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
    isContinuousScanEnabledInInventory: faker.randomGenerator.boolean(),
  );

  static TransferJustificationEntity makeTransferJustificationEntity() =>
      TransferJustificationEntity(
        CodigoInterno_JustMov: faker.randomGenerator.integer(100),
        Descricao_JustMov: faker.lorem.word(),
        FlagTipo_JustMov: faker.randomGenerator.integer(10),
        FlagInterno_TipoEstoque: faker.randomGenerator.boolean(),
        Nome_TipoEstoque: faker.lorem.word(),
        CodigoInterno_TipoEstoque: faker.randomGenerator.integer(100),
      );

  static StockTypeEntity makeStockTypeEntity() => StockTypeEntity(
    CodigoInterno_TipoEstoque: faker.randomGenerator.integer(100),
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

  static CustomerEntity makeCustomerEntity() => CustomerEntity(
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

  static RequestTypeEntity makeRequestTypeEntity() => RequestTypeEntity(
    Code: faker.randomGenerator.integer(100),
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
    AllowAlterCostOrSalePrice: faker.randomGenerator.boolean(),
    AllowDiscount: faker.randomGenerator.boolean(),
  );

  static SupplierEntity makeSupplierEntity() => SupplierEntity(
    Code: faker.randomGenerator.integer(100),
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

  static PendingBuyRequestEntity makePendingBuyRequestEntity() {
    final enterpriseCode = faker.randomGenerator.integer(100);
    final productPackingCode = faker.randomGenerator.integer(100);

    return PendingBuyRequestEntity(
      selectedRequestType: makeRequestTypeEntity(),
      selectedBuyer: makeBuyerEntity(),
      selectedSupplier: makeSupplierEntity(),
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

  static PendingSaleRequestEntity makePendingSaleRequestEntity({
    CustomerEntity? customer,
  }) => PendingSaleRequestEntity(
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
  );

  static CartProductEntity makeCartProductEntity({
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
        : PercentageOrValue.value;
    final defaultValue = faker.randomGenerator.decimal() * 100;

    return CartProductEntity(
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
    List<CartProductEntity>? products,
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
        pendingSaleRequestEntity: makePendingSaleRequestEntity(),
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

  static ReportScheduleEntity makeReportScheduleEntity() =>
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
        Code: faker.randomGenerator.integer(100),
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
}
