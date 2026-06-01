// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:equatable/equatable.dart';

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
  final PriceCostEntity? PriceCost;
  final List<StockByEnterpriseAssociatedEntity>? StockByEnterpriseAssociateds;
  final List<StockEntity>?
  Stocks; //even when doesnt has permission, is returning the stocks
  final List<LastBuyEntranceEntity>? LastBuyEntrances;
  final List<String>? EANs;
  final int? codigoInternoProEmb; //inventory
  final String? codigoProEmb; //inventory
  final double? quantidadeInvContProEmb; //inventory
  final String? FormatedProduct; //receipt
  final String? ReferenciaXml_ProcRecebDocProEmb; //receipt
  final DateTime? DataValidade_ProcRecebDocProEmb; //receipt
  final double? Quantidade_ProcRecebDocProEmb; //receipt
  final String? PackingAbbreviation; //ecommerce API shallow request

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
    required this.Quantidade_ProcRecebDocProEmb,
    required this.ReferenciaXml_ProcRecebDocProEmb,
    required this.DataValidade_ProcRecebDocProEmb,
    required this.PackingAbbreviation,
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
    FormatedProduct,
    ReferenciaXml_ProcRecebDocProEmb,
    DataValidade_ProcRecebDocProEmb,
    Quantidade_ProcRecebDocProEmb,
    PackingAbbreviation,
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
    String? ReferenciaXml_ProcRecebDocProEmb,
    DateTime? DataValidade_ProcRecebDocProEmb,
    double? Quantidade_ProcRecebDocProEmb,
    String? PackingAbbreviation,
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
      Quantidade_ProcRecebDocProEmb:
          Quantidade_ProcRecebDocProEmb ?? this.Quantidade_ProcRecebDocProEmb,
      ReferenciaXml_ProcRecebDocProEmb:
          ReferenciaXml_ProcRecebDocProEmb ??
          this.ReferenciaXml_ProcRecebDocProEmb,
      DataValidade_ProcRecebDocProEmb:
          DataValidade_ProcRecebDocProEmb ??
          this.DataValidade_ProcRecebDocProEmb,
      PackingAbbreviation: PackingAbbreviation ?? this.PackingAbbreviation,
    );
  }

  double get getPrice {
    if ((Value ?? 0) > 0) {
      return Value ?? 0;
    }

    return PriceCost?.RetailPracticedPrice ?? RetailPracticedPrice ?? 0;
  }

  String get formattedPacking =>
      '($PackingAbbreviation ${PackingQuantity.toString().toBrazilianNumber(3, true)})';

  PracticedPriceType getPracticedPriceType({
    required double quantity,
    required double? manualPrice,
  }) {
    // 1. If the manual price is not null, it must always return the type manual
    if (manualPrice != null) {
      return PracticedPriceType.manual;
    }

    // 2. Determine target active price considering quantity thresholds (wholesale vs. retail)
    final double retailPrice = getPrice;
    final double wholePrice =
        PriceCost?.WholePracticedPrice ?? WholePracticedPrice ?? 0;
    final double minWhole =
        PriceCost?.MinimumWholeQuantity ?? MinimumWholeQuantity ?? 0;

    final double targetPrice;
    if (minWhole > 0 && wholePrice > 0 && quantity >= minWhole) {
      targetPrice = wholePrice;
    } else {
      targetPrice = retailPrice;
    }

    // 3. Direct comparison with O(1) performance lookup
    if (minWhole > 0 &&
        wholePrice > 0 &&
        quantity >= minWhole &&
        targetPrice == wholePrice) {
      return PracticedPriceType.whole;
    } else if (targetPrice ==
        (PriceCost?.RetailPracticedPrice ?? RetailPracticedPrice ?? 0)) {
      return PracticedPriceType.retail;
    } else if (targetPrice == wholePrice && wholePrice > 0) {
      return PracticedPriceType.whole;
    } else if (targetPrice ==
        (PriceCost?.OperationalCost ?? OperationalCost ?? 0)) {
      return PracticedPriceType.operationalCost;
    } else if (targetPrice ==
        (PriceCost?.ReplacementCost ?? ReplacementCost ?? 0)) {
      return PracticedPriceType.replacementCost;
    } else if (targetPrice ==
        (PriceCost?.ReplacementCostMidle ?? ReplacementCostMidle ?? 0)) {
      return PracticedPriceType.replacementCostMidle;
    } else if (targetPrice == (PriceCost?.LiquidCost ?? LiquidCost ?? 0)) {
      return PracticedPriceType.liquidCost;
    } else if (targetPrice ==
        (PriceCost?.LiquidCostMidle ?? LiquidCostMidle ?? 0)) {
      return PracticedPriceType.liquidCostMidle;
    } else if (targetPrice == (PriceCost?.RealCost ?? RealCost ?? 0)) {
      return PracticedPriceType.realCost;
    } else if (targetPrice ==
        (PriceCost?.RealLiquidCost ?? RealLiquidCost ?? 0)) {
      return PracticedPriceType.realLiquidCost;
    } else if (targetPrice == (PriceCost?.FiscalCost ?? FiscalCost ?? 0)) {
      return PracticedPriceType.fiscalCost;
    } else if (targetPrice ==
        (PriceCost?.FiscalLiquidCost ?? FiscalLiquidCost ?? 0)) {
      return PracticedPriceType.fiscalLiquidCost;
    } else if (targetPrice ==
        (PriceCost?.ECommercePracticedPrice ?? ECommercePracticedPrice ?? 0)) {
      return PracticedPriceType.ecommerce;
    }

    return PracticedPriceType.retail;
  }

  double getPracticedPrice({required double quantity, double? manualPrice}) {
    final type = getPracticedPriceType(
      quantity: quantity,
      manualPrice: manualPrice,
    );

    // Performance optimization: Exhaustive switch enables O(1) branch lookup and zero runtime allocations.
    switch (type) {
      case PracticedPriceType.manual:
        return manualPrice ?? 0;
      case PracticedPriceType.retail:
        return getPrice;
      case PracticedPriceType.whole:
        return PriceCost?.WholePracticedPrice ?? WholePracticedPrice ?? 0;
      case PracticedPriceType.operationalCost:
        return PriceCost?.OperationalCost ?? OperationalCost ?? 0;
      case PracticedPriceType.replacementCost:
        return PriceCost?.ReplacementCost ?? ReplacementCost ?? 0;
      case PracticedPriceType.replacementCostMidle:
        return PriceCost?.ReplacementCostMidle ?? ReplacementCostMidle ?? 0;
      case PracticedPriceType.liquidCost:
        return PriceCost?.LiquidCost ?? LiquidCost ?? 0;
      case PracticedPriceType.liquidCostMidle:
        return PriceCost?.LiquidCostMidle ?? LiquidCostMidle ?? 0;
      case PracticedPriceType.definedBySystem:
        final wholePrice =
            PriceCost?.WholePracticedPrice ?? WholePracticedPrice ?? 0;
        final minWhole =
            PriceCost?.MinimumWholeQuantity ?? MinimumWholeQuantity ?? 0;
        return (minWhole > 0 && wholePrice > 0 && quantity >= minWhole)
            ? wholePrice
            : getPrice;
      case PracticedPriceType.realCost:
        return PriceCost?.RealCost ?? RealCost ?? 0;
      case PracticedPriceType.realLiquidCost:
        return PriceCost?.RealLiquidCost ?? RealLiquidCost ?? 0;
      case PracticedPriceType.fiscalCost:
        return PriceCost?.FiscalCost ?? FiscalCost ?? 0;
      case PracticedPriceType.fiscalLiquidCost:
        return PriceCost?.FiscalLiquidCost ?? FiscalLiquidCost ?? 0;
      case PracticedPriceType.ecommerce:
        return PriceCost?.ECommercePracticedPrice ??
            ECommercePracticedPrice ??
            0;
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
    Quantidade_ProcRecebDocProEmb: null,
    ReferenciaXml_ProcRecebDocProEmb: null,
    DataValidade_ProcRecebDocProEmb: null,
    PackingAbbreviation: null,
  );

  ProductEntity annuValues({
    bool? annulEnterpriseCode,
    bool? annulProductCode,
    bool? annulProductPackingCode,
    bool? annulPLU,
    bool? annulName,
    bool? annulPackingQuantity,
    bool? annulBalanceLabelType,
    bool? annulStorageAreaAddress,
    bool? annulValue,
    bool? annulBalanceLabelQuantity,
    bool? annulRetailPracticedPrice,
    bool? annulRetailSalePrice,
    bool? annulRetailOfferPrice,
    bool? annulWholePracticedPrice,
    bool? annulWholeSalePrice,
    bool? annulWholeOfferPrice,
    bool? annulECommercePracticedPrice,
    bool? annulECommerceSalePrice,
    bool? annulECommerceOfferPrice,
    bool? annulMinimumWholeQuantity,
    bool? annulOperationalCost,
    bool? annulReplacementCost,
    bool? annulReplacementCostMidle,
    bool? annulLiquidCost,
    bool? annulLiquidCostMidle,
    bool? annulRealCost,
    bool? annulRealLiquidCost,
    bool? annulFiscalCost,
    bool? annulFiscalLiquidCost,
    bool? annulPendantPrintLabel,
    bool? annulAlterationPriceForAllPackings,
    bool? annulIsFatherOfGrate,
    bool? annulIsChildOfGrate,
    bool? annulInClass,
    bool? annulMarkUpdateClassInAdjustSalePriceIndividual,
    bool? annulPriceCost,
    bool? annulStockByEnterpriseAssociateds,
    bool? annulStocks,
    bool? annulLastBuyEntrances,
    bool? annulEANs,
    bool? annulResearchOfPriceCode,
    bool? annulConcurrentCode,
    bool? annulcodigoInternoProEmb,
    bool? annulcodigoProEmb,
    bool? annulquantidadeInvContProEmb,
    bool? annulFormatedProduct,
    bool? annulQuantidade_ProcRecebDocProEmb,
    bool? annulReferenciaXml_ProcRecebDocProEmb,
    bool? annulDataValidade_ProcRecebDocProEmb,
    bool? annulPackingAbbreviation,
  }) => ProductEntity(
    PackingAbbreviation: annulPackingAbbreviation == true
        ? null
        : PackingAbbreviation,
    EnterpriseCode: annulEnterpriseCode == true ? null : EnterpriseCode,
    ProductCode: annulProductCode == true ? null : ProductCode,
    ProductPackingCode: annulProductPackingCode == true
        ? null
        : ProductPackingCode,
    PLU: annulPLU == true ? null : PLU,
    Name: annulName == true ? null : Name,
    PackingQuantity: annulPackingQuantity == true ? null : PackingQuantity,
    BalanceLabelType: annulBalanceLabelType == true ? null : BalanceLabelType,
    StorageAreaAddress: annulStorageAreaAddress == true
        ? null
        : StorageAreaAddress,
    Value: annulValue == true ? null : Value,
    BalanceLabelQuantity: annulBalanceLabelQuantity == true
        ? null
        : BalanceLabelQuantity,
    RetailPracticedPrice: annulRetailPracticedPrice == true
        ? null
        : RetailPracticedPrice,
    RetailSalePrice: annulRetailSalePrice == true ? null : RetailSalePrice,
    RetailOfferPrice: annulRetailOfferPrice == true ? null : RetailOfferPrice,
    WholePracticedPrice: annulWholePracticedPrice == true
        ? null
        : WholePracticedPrice,
    WholeSalePrice: annulWholeSalePrice == true ? null : WholeSalePrice,
    WholeOfferPrice: annulWholeOfferPrice == true ? null : WholeOfferPrice,
    ECommercePracticedPrice: annulECommercePracticedPrice == true
        ? null
        : ECommercePracticedPrice,
    ECommerceSalePrice: annulECommerceSalePrice == true
        ? null
        : ECommerceSalePrice,
    ECommerceOfferPrice: annulECommerceOfferPrice == true
        ? null
        : ECommerceOfferPrice,
    MinimumWholeQuantity: annulMinimumWholeQuantity == true
        ? null
        : MinimumWholeQuantity,
    OperationalCost: annulOperationalCost == true ? null : OperationalCost,
    ReplacementCost: annulReplacementCost == true ? null : ReplacementCost,
    ReplacementCostMidle: annulReplacementCostMidle == true
        ? null
        : ReplacementCostMidle,
    LiquidCost: annulLiquidCost == true ? null : LiquidCost,
    LiquidCostMidle: annulLiquidCostMidle == true ? null : LiquidCostMidle,
    RealCost: annulRealCost == true ? null : RealCost,
    RealLiquidCost: annulRealLiquidCost == true ? null : RealLiquidCost,
    FiscalCost: annulFiscalCost == true ? null : FiscalCost,
    FiscalLiquidCost: annulFiscalLiquidCost == true ? null : FiscalLiquidCost,
    PendantPrintLabel: annulPendantPrintLabel == true
        ? null
        : PendantPrintLabel,
    AlterationPriceForAllPackings: annulAlterationPriceForAllPackings == true
        ? null
        : AlterationPriceForAllPackings,
    IsFatherOfGrate: annulIsFatherOfGrate == true ? null : IsFatherOfGrate,
    IsChildOfGrate: annulIsChildOfGrate == true ? null : IsChildOfGrate,
    InClass: annulInClass == true ? null : InClass,
    MarkUpdateClassInAdjustSalePriceIndividual:
        annulMarkUpdateClassInAdjustSalePriceIndividual == true
        ? null
        : MarkUpdateClassInAdjustSalePriceIndividual,
    PriceCost: annulPriceCost == true ? null : PriceCost,
    StockByEnterpriseAssociateds: annulStockByEnterpriseAssociateds == true
        ? null
        : StockByEnterpriseAssociateds,
    Stocks: annulStocks == true ? null : Stocks,
    LastBuyEntrances: annulLastBuyEntrances == true ? null : LastBuyEntrances,
    EANs: annulEANs == true ? null : EANs,
    ResearchOfPriceCode: annulResearchOfPriceCode == true
        ? null
        : ResearchOfPriceCode,
    ConcurrentCode: annulConcurrentCode == true ? null : ConcurrentCode,
    codigoInternoProEmb: annulcodigoInternoProEmb == true
        ? null
        : codigoInternoProEmb,
    codigoProEmb: annulcodigoProEmb == true ? null : codigoProEmb,
    quantidadeInvContProEmb: annulquantidadeInvContProEmb == true
        ? null
        : quantidadeInvContProEmb,
    FormatedProduct: annulFormatedProduct == true ? null : FormatedProduct,
    Quantidade_ProcRecebDocProEmb: annulQuantidade_ProcRecebDocProEmb == true
        ? null
        : Quantidade_ProcRecebDocProEmb,
    ReferenciaXml_ProcRecebDocProEmb:
        annulReferenciaXml_ProcRecebDocProEmb == true
        ? null
        : ReferenciaXml_ProcRecebDocProEmb,
    DataValidade_ProcRecebDocProEmb:
        annulDataValidade_ProcRecebDocProEmb == true
        ? null
        : DataValidade_ProcRecebDocProEmb,
  );
}
