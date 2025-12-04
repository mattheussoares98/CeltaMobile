// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'product.dart';

class ProductEntity extends Equatable {
  final int? EnterpriseCode;
  final int? ProductCode;
  final int? ProductPackingCode;
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
  final int? ResearchOfPriceCode;
  final int? ConcurrentCode;
  final PriceCostEntity?
  PriceCost; //TODO test when the user doesnt has permission
  final List<StockByEnterpriseAssociatedEntity>?
  StockByEnterpriseAssociateds; //TODO test when the user doesnt has permission
  final List<StockEntity>?
  Stocks; //TODO test when the user doesnt has permission
  final List<LastBuyEntranceEntity>? LastBuyEntrances;
  final List<String>? EANs;
  final int? codigoInternoProEmb; //inventory
  final String? codigoProEmb; //inventory
  final double? quantidadeInvContProEmb; //inventory
  final String? FormatedProduct; //receipt

  const ProductEntity({
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
    required this.ResearchOfPriceCode,
    required this.ConcurrentCode,
    required this.codigoInternoProEmb,
    required this.codigoProEmb,
    required this.quantidadeInvContProEmb,
    required this.FormatedProduct,
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
    codigoInternoProEmb,
    codigoProEmb,
    quantidadeInvContProEmb,
  ];

  ProductEntity copyWith({
    int? EnterpriseCode,
    int? ProductCode,
    int? ProductPackingCode,
    String? PLU,
    String? Name,
    String? PackingQuantity,
    String? BalanceLabelType,
    String? StorageAreaAddress,
    double? Value,
    double? BalanceLabelQuantity,
    double? RetailPracticedPrice,
    double? RetailSalePrice,
    double? RetailOfferPrice,
    double? WholePracticedPrice,
    double? WholeSalePrice,
    double? WholeOfferPrice,
    double? ECommercePracticedPrice,
    double? ECommerceSalePrice,
    double? ECommerceOfferPrice,
    double? MinimumWholeQuantity,
    double? OperationalCost,
    double? ReplacementCost,
    double? ReplacementCostMidle,
    double? LiquidCost,
    double? LiquidCostMidle,
    double? RealCost,
    double? RealLiquidCost,
    double? FiscalCost,
    double? FiscalLiquidCost,
    bool? PendantPrintLabel,
    bool? AlterationPriceForAllPackings,
    bool? IsFatherOfGrate,
    bool? IsChildOfGrate,
    bool? InClass,
    bool? MarkUpdateClassInAdjustSalePriceIndividual,
    PriceCostEntity? PriceCost,
    List<StockByEnterpriseAssociatedEntity>? StockByEnterpriseAssociateds,
    List<StockEntity>? Stocks,
    List<LastBuyEntranceEntity>? LastBuyEntrances,
    List<String>? EANs,
    int? ResearchOfPriceCode,
    int? ConcurrentCode,
    int? codigoInternoProEmb,
    String? codigoProEmb,
    double? quantidadeInvContProEmb,
    String? FormatedProduct,
  }) {
    return ProductEntity(
      EnterpriseCode: EnterpriseCode ?? this.EnterpriseCode,
      ProductCode: ProductCode ?? this.ProductCode,
      ProductPackingCode: ProductPackingCode ?? this.ProductPackingCode,
      PLU: PLU ?? this.PLU,
      Name: Name ?? this.Name,
      PackingQuantity: PackingQuantity ?? this.PackingQuantity,
      BalanceLabelType: BalanceLabelType ?? this.BalanceLabelType,
      StorageAreaAddress: StorageAreaAddress ?? this.StorageAreaAddress,
      Value: Value ?? this.Value,
      BalanceLabelQuantity: BalanceLabelQuantity ?? this.BalanceLabelQuantity,
      RetailPracticedPrice: RetailPracticedPrice ?? this.RetailPracticedPrice,
      RetailSalePrice: RetailSalePrice ?? this.RetailSalePrice,
      RetailOfferPrice: RetailOfferPrice ?? this.RetailOfferPrice,
      WholePracticedPrice: WholePracticedPrice ?? this.WholePracticedPrice,
      WholeSalePrice: WholeSalePrice ?? this.WholeSalePrice,
      WholeOfferPrice: WholeOfferPrice ?? this.WholeOfferPrice,
      ECommercePracticedPrice:
          ECommercePracticedPrice ?? this.ECommercePracticedPrice,
      ECommerceSalePrice: ECommerceSalePrice ?? this.ECommerceSalePrice,
      ECommerceOfferPrice: ECommerceOfferPrice ?? this.ECommerceOfferPrice,
      MinimumWholeQuantity: MinimumWholeQuantity ?? this.MinimumWholeQuantity,
      OperationalCost: OperationalCost ?? this.OperationalCost,
      ReplacementCost: ReplacementCost ?? this.ReplacementCost,
      ReplacementCostMidle: ReplacementCostMidle ?? this.ReplacementCostMidle,
      LiquidCost: LiquidCost ?? this.LiquidCost,
      LiquidCostMidle: LiquidCostMidle ?? this.LiquidCostMidle,
      RealCost: RealCost ?? this.RealCost,
      RealLiquidCost: RealLiquidCost ?? this.RealLiquidCost,
      FiscalCost: FiscalCost ?? this.FiscalCost,
      FiscalLiquidCost: FiscalLiquidCost ?? this.FiscalLiquidCost,
      PendantPrintLabel: PendantPrintLabel ?? this.PendantPrintLabel,
      AlterationPriceForAllPackings:
          AlterationPriceForAllPackings ?? this.AlterationPriceForAllPackings,
      IsFatherOfGrate: IsFatherOfGrate ?? this.IsFatherOfGrate,
      IsChildOfGrate: IsChildOfGrate ?? this.IsChildOfGrate,
      InClass: InClass ?? this.InClass,
      MarkUpdateClassInAdjustSalePriceIndividual:
          MarkUpdateClassInAdjustSalePriceIndividual ??
          this.MarkUpdateClassInAdjustSalePriceIndividual,
      PriceCost: PriceCost ?? this.PriceCost,
      StockByEnterpriseAssociateds:
          StockByEnterpriseAssociateds ?? this.StockByEnterpriseAssociateds,
      Stocks: Stocks ?? this.Stocks,
      LastBuyEntrances: LastBuyEntrances ?? this.LastBuyEntrances,
      EANs: EANs ?? this.EANs,
      ResearchOfPriceCode: ResearchOfPriceCode ?? this.ResearchOfPriceCode,
      ConcurrentCode: ConcurrentCode ?? this.ConcurrentCode,
      codigoInternoProEmb: codigoInternoProEmb ?? this.codigoInternoProEmb,
      codigoProEmb: codigoProEmb ?? this.codigoProEmb,
      quantidadeInvContProEmb:
          quantidadeInvContProEmb ?? this.quantidadeInvContProEmb,
      FormatedProduct: FormatedProduct ?? this.FormatedProduct,
    );
  }

  double get getPrice {
    if ((Value ?? 0) > 0) {
      return Value ?? 0;
    }

    return RetailPracticedPrice ?? 0;
  }

  PracticedPriceType getPracticedPriceType({
    required double quantity,
    required double? manualPrice,
  }) {
    if (getPrice == 0 && (manualPrice ?? 0) == 0) {
      return PracticedPriceType.notDefined;
    } else if (manualPrice == getPrice) {
      return PracticedPriceType.retail;
    } else if (manualPrice == WholePracticedPrice &&
        (WholePracticedPrice ?? 0) > 0) {
      return PracticedPriceType.whole;
    } else if (manualPrice != null && manualPrice > 0) {
      return PracticedPriceType.manual;
    } else if ((MinimumWholeQuantity ?? 0) > 0 &&
        (WholePracticedPrice ?? 0) > 0 &&
        quantity >= (MinimumWholeQuantity ?? 0)) {
      return PracticedPriceType.whole;
    }
    return PracticedPriceType.retail;
  }

  double getPracticedPrice({required double quantity, double? manualPrice}) {
    final type = getPracticedPriceType(
      quantity: quantity,
      manualPrice: manualPrice,
    );

    switch (type) {
      case PracticedPriceType.notDefined:
        return manualPrice ?? 0;
      case PracticedPriceType.retail:
        return getPrice;
      case PracticedPriceType.whole:
        return (WholePracticedPrice ?? 0);
      case PracticedPriceType.manual:
        return manualPrice ?? 0;
    }
  }

  factory ProductEntity.empty() => const ProductEntity(
    EnterpriseCode: null,
    ProductCode: null,
    ProductPackingCode: null,
    PLU: null,
    Name: null,
    PackingQuantity: null,
    BalanceLabelType: null,
    StorageAreaAddress: null,
    Value: null,
    BalanceLabelQuantity: null,
    RetailPracticedPrice: null,
    RetailSalePrice: null,
    RetailOfferPrice: null,
    WholePracticedPrice: null,
    WholeSalePrice: null,
    WholeOfferPrice: null,
    ECommercePracticedPrice: null,
    ECommerceSalePrice: null,
    ECommerceOfferPrice: null,
    MinimumWholeQuantity: null,
    OperationalCost: null,
    ReplacementCost: null,
    ReplacementCostMidle: null,
    LiquidCost: null,
    LiquidCostMidle: null,
    RealCost: null,
    RealLiquidCost: null,
    FiscalCost: null,
    FiscalLiquidCost: null,
    PendantPrintLabel: null,
    AlterationPriceForAllPackings: null,
    IsFatherOfGrate: null,
    IsChildOfGrate: null,
    InClass: null,
    MarkUpdateClassInAdjustSalePriceIndividual: null,
    PriceCost: null,
    StockByEnterpriseAssociateds: null,
    Stocks: null,
    LastBuyEntrances: null,
    EANs: null,
    ResearchOfPriceCode: null,
    ConcurrentCode: null,
    codigoInternoProEmb: null,
    codigoProEmb: null,
    quantidadeInvContProEmb: null,
    FormatedProduct: null,
  );
}

enum PracticedPriceType {
  manual('Manual'),
  notDefined('Não definido'),
  retail('Varejo'),
  whole('Atacado');

  final String name;
  const PracticedPriceType(this.name);
}
