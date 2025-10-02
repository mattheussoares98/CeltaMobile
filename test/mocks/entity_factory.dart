import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/features/adjust_sale_price/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/entities/customer/customer.dart';
import 'package:celta_intelligence/features/enterprise_manager/domain/entities/entities.dart';
import 'package:celta_intelligence/features/transfer_between_stocks/domain/entities/entities.dart';
import 'package:faker/faker.dart';

class EntityFactory {
  EntityFactory._();

  static EnterpriseEntity makeEnterpriseEntity({int? id, String? name}) =>
      EnterpriseEntity(
        id: id ?? faker.randomGenerator.integer(100),
        name: name ?? faker.company.name(),
        baseUrl: faker.internet.httpsUrl(),
        subEnterprises: [
          makeSubEnterpriseEntity(),
          makeSubEnterpriseEntity(),
          makeSubEnterpriseEntity(),
        ],
        CnpjNumber: faker.randomGenerator.integer(100).toString(),
        Code: faker.randomGenerator.integer(100),
        CodigoInternoVendaMobile_ModeloPedido: faker.randomGenerator.integer(
          100,
        ),
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

  static ProductEntity makeProductEntity() => ProductEntity(
    EnterpriseCode: faker.randomGenerator.integer(100),
    ProductCode: faker.randomGenerator.integer(100),
    ProductPackingCode: faker.randomGenerator.integer(100),
    PLU: faker.randomGenerator.integer(100).toString(),
    Name: faker.food.dish(),
    PackingQuantity: faker.randomGenerator.integer(100).toString(),
    BalanceLabelType: faker.lorem.word(),
    StorageAreaAddress: faker.guid.guid(),
    Value: faker.randomGenerator.decimal(),
    BalanceLabelQuantity: faker.randomGenerator.decimal(),
    RetailPracticedPrice: faker.randomGenerator.decimal(),
    RetailSalePrice: faker.randomGenerator.decimal(),
    RetailOfferPrice: faker.randomGenerator.decimal(),
    WholePracticedPrice: faker.randomGenerator.decimal(),
    WholeSalePrice: faker.randomGenerator.decimal(),
    WholeOfferPrice: faker.randomGenerator.decimal(),
    ECommercePracticedPrice: faker.randomGenerator.decimal(),
    ECommerceSalePrice: faker.randomGenerator.decimal(),
    ECommerceOfferPrice: faker.randomGenerator.decimal(),
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

  static UserSessionEntity makeUserSessionEntity() => UserSessionEntity(
    user: makeUserEntity(),
    supabaseEnterprise: makeEnterpriseEntity(),
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
        product: makeProductEntity(),
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
    DateOfBirth: faker.date.dateTime(),
    SexType: faker.randomGenerator.integer(1) == 1 ? "M" : "F",
    PersonType: faker.randomGenerator.integer(1) == 1 ? "PJ" : "PF",
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
    State: faker.address.state(),
    Complement: faker.address.neighborhood(),
    Reference: faker.address.neighborhood(),
  );

  static CustomerCovenantEntity makeCustomerCovenantEntity() =>
      CustomerCovenantEntity(
        covenant: makeCovenantEntity(),
        Matriculate: faker.guid.guid(),
        LimitOfPurchase: faker.randomGenerator.decimal(),
      );

  static CovenantEntity makeCovenantEntity() => CovenantEntity(
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
}
