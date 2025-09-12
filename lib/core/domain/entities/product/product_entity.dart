import 'package:equatable/equatable.dart';

import 'product.dart';

class ProductEntity extends Equatable {
  final int EnterpriseCode;
  final int ProductCode;
  final int ProductPackingCode;
  final String PLU;
  final String Name;
  final String PackingQuantity;
  final String BalanceLabelType;
  final String? StorageAreaAddress;
  final double Value;
  final double BalanceLabelQuantity;
  final double RetailPracticedPrice;
  final double RetailSalePrice;
  final double RetailOfferPrice;
  final double WholePracticedPrice;
  final double WholeSalePrice;
  final double WholeOfferPrice;
  final double ECommercePracticedPrice;
  final double ECommerceSalePrice;
  final double ECommerceOfferPrice;
  final double MinimumWholeQuantity;
  final double OperationalCost;
  final double ReplacementCost;
  final double ReplacementCostMidle;
  final double LiquidCost;
  final double LiquidCostMidle;
  final double RealCost;
  final double RealLiquidCost;
  final double FiscalCost;
  final double FiscalLiquidCost;
  final bool PendantPrintLabel;
  final bool AlterationPriceForAllPackings;
  final bool IsFatherOfGrate;
  final bool IsChildOfGrate;
  final bool InClass;
  final bool MarkUpdateClassInAdjustSalePriceIndividual;
  final PriceCostEntity
  PriceCost; //TODO test when the user doesnt has permission
  final List<StockByEnterpriseAssociatedsEntity>?
  StockByEnterpriseAssociateds; //TODO test when the user doesnt has permission
  final List<StockEntity>?
  Stocks; //TODO test when the user doesnt has permission
  final List<LastBuyEntranceEntity>? LastBuyEntrances;

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
  ];
}
