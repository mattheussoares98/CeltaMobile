import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';
import 'product.dart';

class ProductModel extends Equatable implements ProductModelType {
  final int? EnterpriseCode;
  final int? ProductCode;
  final int? ProductPackingCode;
  final int? ResearchOfPriceCode;
  final int? ConcurrentCode;
  final String? PLU;
  final String? Name;
  final String? PackingQuantity;
  final String? BalanceLabelType;
  final String? StorageAreaAddress;
  final double? Value;
  final double? BalanceLabelQuantity;
  final double? RetailPracticedPrice;
  final double? RetailSalePrice;
  final double? RetailOfferPrice;
  final double? WholePracticedPrice;
  final double? WholeSalePrice;
  final double? WholeOfferPrice;
  final double? ECommercePracticedPrice;
  final double? ECommerceSalePrice;
  final double? ECommerceOfferPrice;
  final double? MinimumWholeQuantity;
  final double? OperationalCost;
  final double? ReplacementCost;
  final double? ReplacementCostMidle;
  final double? LiquidCost;
  final double? LiquidCostMidle;
  final double? RealCost;
  final double? RealLiquidCost;
  final double? FiscalCost;
  final double? FiscalLiquidCost;
  final bool? PendantPrintLabel;
  final bool? AlterationPriceForAllPackings;
  final bool? IsFatherOfGrate;
  final bool? IsChildOfGrate;
  final bool? InClass;
  final bool? MarkUpdateClassInAdjustSalePriceIndividual;
  final PriceCostModel? PriceCost;
  final List<StockByEnterpriseAssociatedModel>? StockByEnterpriseAssociateds;
  final List<StockModel>? Stocks;
  final List<LastBuyEntranceModel>? LastBuyEntrances;
  final List<String>? EANs;

  const ProductModel({
    required this.ResearchOfPriceCode,
    required this.ConcurrentCode,
    required this.EnterpriseCode,
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.PLU,
    required this.Name,
    required this.PackingQuantity,
    required this.BalanceLabelType,
    required this.StorageAreaAddress,
    required this.Value,
    required this.BalanceLabelQuantity,
    required this.RetailPracticedPrice,
    required this.RetailSalePrice,
    required this.RetailOfferPrice,
    required this.WholePracticedPrice,
    required this.WholeSalePrice,
    required this.WholeOfferPrice,
    required this.ECommercePracticedPrice,
    required this.ECommerceSalePrice,
    required this.ECommerceOfferPrice,
    required this.MinimumWholeQuantity,
    required this.OperationalCost,
    required this.ReplacementCost,
    required this.ReplacementCostMidle,
    required this.LiquidCost,
    required this.LiquidCostMidle,
    required this.RealCost,
    required this.RealLiquidCost,
    required this.FiscalCost,
    required this.FiscalLiquidCost,
    required this.PendantPrintLabel,
    required this.AlterationPriceForAllPackings,
    required this.IsFatherOfGrate,
    required this.IsChildOfGrate,
    required this.InClass,
    required this.MarkUpdateClassInAdjustSalePriceIndividual,
    required this.PriceCost,
    required this.StockByEnterpriseAssociateds,
    required this.Stocks,
    required this.LastBuyEntrances,
    required this.EANs,
  });

  @override
  List<Object?> get props => [
    EnterpriseCode,
    ProductCode,
    ProductPackingCode,
    PLU,
    Name,
    PackingQuantity,
    BalanceLabelType,
    StorageAreaAddress,
    Value,
    BalanceLabelQuantity,
    RetailPracticedPrice,
    RetailSalePrice,
    RetailOfferPrice,
    WholePracticedPrice,
    WholeSalePrice,
    WholeOfferPrice,
    ECommercePracticedPrice,
    ECommerceSalePrice,
    ECommerceOfferPrice,
    MinimumWholeQuantity,
    OperationalCost,
    ReplacementCost,
    ReplacementCostMidle,
    LiquidCost,
    LiquidCostMidle,
    RealCost,
    RealLiquidCost,
    FiscalCost,
    FiscalLiquidCost,
    PendantPrintLabel,
    AlterationPriceForAllPackings,
    IsFatherOfGrate,
    IsChildOfGrate,
    InClass,
    MarkUpdateClassInAdjustSalePriceIndividual,
    PriceCost,
    StockByEnterpriseAssociateds,
    Stocks,
    LastBuyEntrances,
    EANs,
    ResearchOfPriceCode,
    ConcurrentCode,
  ];

  factory ProductModel.fromJson(Map json) {
    return ProductModel(
      ResearchOfPriceCode:
          json['ResearchOfPriceCode'], //get this property only in the other model
      ConcurrentCode:
          json['ConcurrentCode'], //get this property only in the other model
      EnterpriseCode: json['EnterpriseCode'],
      ProductCode: json['ProductCode'],
      ProductPackingCode: json['ProductPackingCode'],
      PLU: json['PLU'],
      Name: json['Name'],
      PackingQuantity: json['PackingQuantity'],
      BalanceLabelType: json['BalanceLabelType'],
      StorageAreaAddress: json['StorageAreaAddress'],
      Value: json['Value'],
      BalanceLabelQuantity: json['BalanceLabelQuantity'],
      RetailPracticedPrice: json['RetailPracticedPrice'],
      RetailSalePrice: json['RetailSalePrice'],
      RetailOfferPrice: json['RetailOfferPrice'],
      WholePracticedPrice: json['WholePracticedPrice'],
      WholeSalePrice: json['WholeSalePrice'],
      WholeOfferPrice: json['WholeOfferPrice'],
      ECommercePracticedPrice: json['ECommercePracticedPrice'],
      ECommerceSalePrice: json['ECommerceSalePrice'],
      ECommerceOfferPrice: json['ECommerceOfferPrice'],
      MinimumWholeQuantity: json['MinimumWholeQuantity'],
      OperationalCost: json['OperationalCost'],
      ReplacementCost: json['ReplacementCost'],
      ReplacementCostMidle: json['ReplacementCostMidle'],
      LiquidCost: json['LiquidCost'],
      LiquidCostMidle: json['LiquidCostMidle'],
      RealCost: json['RealCost'],
      RealLiquidCost: json['RealLiquidCost'],
      FiscalCost: json['FiscalCost'],
      FiscalLiquidCost: json['FiscalLiquidCost'],
      PendantPrintLabel: json['PendantPrintLabel'] ?? false,
      AlterationPriceForAllPackings:
          json['AlterationPriceForAllPackings'] ?? false,
      IsFatherOfGrate: json['IsFatherOfGrate'] ?? false,
      IsChildOfGrate: json['IsChildOfGrate'] ?? false,
      InClass: json['InClass'] ?? false,
      MarkUpdateClassInAdjustSalePriceIndividual:
          json['MarkUpdateClassInAdjustSalePriceIndividual'] ?? false,
      PriceCost: json['PriceCost'] == null
          ? null
          : PriceCostModel.fromJson(json['PriceCost']),
      StockByEnterpriseAssociateds: json['StockByEnterpriseAssociateds'] == null
          ? null
          : (json['StockByEnterpriseAssociateds'] as List)
                .map((e) => StockByEnterpriseAssociatedModel.fromJson(e))
                .toList(),
      Stocks: json['Stocks'] == null
          ? null
          : (json['Stocks'] as List)
                .map((e) => StockModel.fromJson(e))
                .toList(),
      LastBuyEntrances: json['LastBuyEntrances'] == null
          ? null
          : (json['LastBuyEntrances'] as List)
                .map((e) => LastBuyEntranceModel.fromJson(e))
                .toList(),
      EANs: json['EANs'] == null ? null : List<String>.from(json['EANs']),
    );
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'EnterpriseCode': EnterpriseCode,
    'ProductCode': ProductCode,
    'ProductPackingCode': ProductPackingCode,
    'PLU': PLU,
    'Name': Name,
    'PackingQuantity': PackingQuantity,
    'BalanceLabelType': BalanceLabelType,
    'StorageAreaAddress': StorageAreaAddress,
    'Value': Value,
    'BalanceLabelQuantity': BalanceLabelQuantity,
    'RetailPracticedPrice': RetailPracticedPrice,
    'RetailSalePrice': RetailSalePrice,
    'RetailOfferPrice': RetailOfferPrice,
    'WholePracticedPrice': WholePracticedPrice,
    'WholeSalePrice': WholeSalePrice,
    'WholeOfferPrice': WholeOfferPrice,
    'ECommercePracticedPrice': ECommercePracticedPrice,
    'ECommerceSalePrice': ECommerceSalePrice,
    'ECommerceOfferPrice': ECommerceOfferPrice,
    'MinimumWholeQuantity': MinimumWholeQuantity,
    'OperationalCost': OperationalCost,
    'ReplacementCost': ReplacementCost,
    'ReplacementCostMidle': ReplacementCostMidle,
    'LiquidCost': LiquidCost,
    'LiquidCostMidle': LiquidCostMidle,
    'RealCost': RealCost,
    'RealLiquidCost': RealLiquidCost,
    'FiscalCost': FiscalCost,
    'FiscalLiquidCost': FiscalLiquidCost,
    'PendantPrintLabel': PendantPrintLabel,
    'AlterationPriceForAllPackings': AlterationPriceForAllPackings,
    'IsFatherOfGrate': IsFatherOfGrate,
    'IsChildOfGrate': IsChildOfGrate,
    'InClass': InClass,
    'MarkUpdateClassInAdjustSalePriceIndividual':
        MarkUpdateClassInAdjustSalePriceIndividual,
    'PriceCost': PriceCost?.toJson(),
    'StockByEnterpriseAssociateds': StockByEnterpriseAssociateds?.map(
      (e) => e.toJson(),
    ).toList(),
    'Stocks': Stocks?.map((e) => e.toJson()).toList(),
    'LastBuyEntrances': LastBuyEntrances?.map((e) => e.toJson()).toList(),
    'EANs': EANs,
    'ResearchOfPriceCode': ResearchOfPriceCode,
    'ConcurrentCode': ConcurrentCode,
  };

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      EnterpriseCode: entity.EnterpriseCode,
      ResearchOfPriceCode: entity.ResearchOfPriceCode,
      ConcurrentCode: entity.ConcurrentCode,
      ProductCode: entity.ProductCode,
      ProductPackingCode: entity.ProductPackingCode,
      PLU: entity.PLU,
      Name: entity.Name,
      PackingQuantity: entity.PackingQuantity,
      BalanceLabelType: entity.BalanceLabelType,
      StorageAreaAddress: entity.StorageAreaAddress,
      Value: entity.Value,
      BalanceLabelQuantity: entity.BalanceLabelQuantity,
      RetailPracticedPrice: entity.RetailPracticedPrice,
      RetailSalePrice: entity.RetailSalePrice,
      RetailOfferPrice: entity.RetailOfferPrice,
      WholePracticedPrice: entity.WholePracticedPrice,
      WholeSalePrice: entity.WholeSalePrice,
      WholeOfferPrice: entity.WholeOfferPrice,
      ECommercePracticedPrice: entity.ECommercePracticedPrice,
      ECommerceSalePrice: entity.ECommerceSalePrice,
      ECommerceOfferPrice: entity.ECommerceOfferPrice,
      MinimumWholeQuantity: entity.MinimumWholeQuantity,
      OperationalCost: entity.OperationalCost,
      ReplacementCost: entity.ReplacementCost,
      ReplacementCostMidle: entity.ReplacementCostMidle,
      LiquidCost: entity.LiquidCost,
      LiquidCostMidle: entity.LiquidCostMidle,
      RealCost: entity.RealCost,
      RealLiquidCost: entity.RealLiquidCost,
      FiscalCost: entity.FiscalCost,
      FiscalLiquidCost: entity.FiscalLiquidCost,
      PendantPrintLabel: entity.PendantPrintLabel,
      AlterationPriceForAllPackings: entity.AlterationPriceForAllPackings,
      IsFatherOfGrate: entity.IsFatherOfGrate,
      IsChildOfGrate: entity.IsChildOfGrate,
      InClass: entity.InClass,
      MarkUpdateClassInAdjustSalePriceIndividual:
          entity.MarkUpdateClassInAdjustSalePriceIndividual,
      PriceCost: entity.PriceCost == null
          ? null
          : PriceCostModel.fromEntity(entity.PriceCost!),
      StockByEnterpriseAssociateds: entity.StockByEnterpriseAssociateds?.map((
        e,
      ) {
        return StockByEnterpriseAssociatedModel.fromEntity(e);
      }).toList(),
      Stocks: entity.Stocks?.map((e) => StockModel.fromEntity(e)).toList(),
      LastBuyEntrances: entity.LastBuyEntrances?.map(
        (e) => LastBuyEntranceModel.fromEntity(e),
      ).toList(),
      EANs: entity.EANs,
    );
  }

  @override
  ProductEntity toEntity() => ProductEntity.empty().copyWith(
    ResearchOfPriceCode: ResearchOfPriceCode,
    ConcurrentCode: ConcurrentCode,
    EnterpriseCode: EnterpriseCode,
    ProductCode: ProductCode,
    ProductPackingCode: ProductPackingCode,
    PLU: PLU,
    Name: Name,
    PackingQuantity: PackingQuantity,
    BalanceLabelType: BalanceLabelType,
    StorageAreaAddress: StorageAreaAddress,
    Value: Value,
    BalanceLabelQuantity: BalanceLabelQuantity,
    RetailPracticedPrice: RetailPracticedPrice,
    RetailSalePrice: RetailSalePrice,
    RetailOfferPrice: RetailOfferPrice,
    WholePracticedPrice: WholePracticedPrice,
    WholeSalePrice: WholeSalePrice,
    WholeOfferPrice: WholeOfferPrice,
    ECommercePracticedPrice: ECommercePracticedPrice,
    ECommerceSalePrice: ECommerceSalePrice,
    ECommerceOfferPrice: ECommerceOfferPrice,
    MinimumWholeQuantity: MinimumWholeQuantity,
    OperationalCost: OperationalCost,
    ReplacementCost: ReplacementCost,
    ReplacementCostMidle: ReplacementCostMidle,
    LiquidCost: LiquidCost,
    LiquidCostMidle: LiquidCostMidle,
    RealCost: RealCost,
    RealLiquidCost: RealLiquidCost,
    FiscalCost: FiscalCost,
    FiscalLiquidCost: FiscalLiquidCost,
    PendantPrintLabel: PendantPrintLabel,
    AlterationPriceForAllPackings: AlterationPriceForAllPackings,
    IsFatherOfGrate: IsFatherOfGrate,
    IsChildOfGrate: IsChildOfGrate,
    InClass: InClass,
    MarkUpdateClassInAdjustSalePriceIndividual:
        MarkUpdateClassInAdjustSalePriceIndividual,
    PriceCost: PriceCost?.toEntity(),
    StockByEnterpriseAssociateds: StockByEnterpriseAssociateds?.map(
      (e) => e.toEntity(),
    ).toList(),
    Stocks: Stocks?.map((e) => e.toEntity()).toList(),
    LastBuyEntrances: LastBuyEntrances?.map((e) => e.toEntity()).toList(),
    EANs: EANs,
  );
}
