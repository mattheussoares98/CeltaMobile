import '../../../../../core/domain/entities/entities.dart';
import '../../../../../utils/utils.dart';
import '../entities.dart' hide ProductPackingCode;

extension ProductEntityToBSFProductItemEntity on ProductEntity {
  BSFProductItemEntity toBSFProductItemEntity() {
    return BSFProductItemEntity(
      product: BSFProductDetailsEntity(
        name: Name,
        isAlcoholicProduct: false,
        isFatherOfGrate: IsFatherOfGrate,
        fatherGrateCode: null,
        images: null,
        personalizedCode:
            ProductPackingCode?.toString() ?? ProductCode?.toString(),
        productPackingTypeString: PackingAbbreviation,
        productPackingQuantity: PackingQuantity?.toDouble(),
        productPackingPriceLookUpString: PLU,
        code: ProductPackingCode,
        productPackingPersonalizedCodeString: ProductPackingCode?.toString(),
        productPackingQuantityString: PackingQuantity?.toString(),
        productPackingString: ProductPackingCode?.toString(),
        manufacturerString: null,
        productPackingSpecificationString: null,
        complement: null,
        consolidateGrateChildsInFiscalNote: null,
        fatherOfGrateIsLiberatedSale: null,
        isBasicBasketItem: null,
        isDesativate: null,
        isFloatingProduct: null,
        isOutOfLine: null,
        isPriceControlled: null,
        isProductForComplementFiscalNote: null,
        isReturnablePacking: null,
        isScheduledToUnify: null,
        legacyCode: null,
        practicePriceRoundRules: null,
        productPackingEanString: null,
      ),
      productPackingCode: ProductPackingCode,
      ipi: null,
      icms: null,
      code: 0,
      fiscalCode: null,
      compositionChilds: null,
      eanCode: EANs?.firstOrNull,
      freight: null,
      discounts: const [],
      expectedDeliveryDate: null,
      deliveryTax: null,
      increment: null,
      creditOnOrigin: null,
      compensation: null,
      quantity: null,
      value: getPrice,
      priceCost: PriceCost?.toBSFPriceCostEntity(),
    );
  }
}

extension PriceCostEntityToBSFPriceCostEntity on PriceCostEntity {
  BSFPriceCostEntity toBSFPriceCostEntity() {
    return BSFPriceCostEntity(
      saleRetailPricePractice: RetailPracticedPrice,
      lastSaleRetailPrice: null,
      wholeSalePricePractice: WholePracticedPrice,
      lastWholeSalePrice: null,
      eCommercePricePractice: ECommercePracticedPrice,
      lastECommercePrice: null,
      saleRetailOfferPractice: RetailOfferPrice,
      lastSaleRetailOffer: null,
      wholeSaleOfferPractice: WholeOfferPrice,
      lastWholeSaleOffer: null,
      eCommerceOfferPractice: ECommerceOfferPrice,
      lastECommerceOffer: null,
      replacementCost: ReplacementCost,
      lastReplacementCost: null,
      mediumReplacementCost: ReplacementCostMidle,
      subsidizedReplacementCost: null,
      activeSubsidizedReplacementCost: null,
      liquidCost: LiquidCost,
      lastLiquidCost: null,
      lastUnitValue: null,
      baseCalcIcmsSubstUnit: null,
      valueOfIcmsSubstUnit: null,
      valueOfIcmsOwnerUnit: null,
      mininumQuantityForWholeSale: MinimumWholeQuantity,
      mediumLiquidCost: LiquidCostMidle,
      subsidizedLiquidCost: null,
      activeSubsidizedLiquidCost: null,
      fiscalBaseCalcSubstitute: null,
      fiscalBaseCalcSubstitutePrevious: null,
      replacementCostReal: RealCost,
      lastReplacementCostReal: null,
      liquidCostReal: RealLiquidCost,
      lastLiquidCostReal: null,
      replacementCostFiscal: FiscalCost,
      lastReplacementCostFiscal: null,
      liquidCostFiscal: FiscalLiquidCost,
      lastLiquidCostFiscal: null,
      operationCost: OperationalCost,
      bonusSubsidyValue: null,
      bonusSubsidyActiveValue: null,
      bonusSubsidyUnitaryValue: null,
      bonusSubsidyActiveUnitaryValue: null,
      isOfferInRetail: null,
      salePracticedTypeInSaleRetail: null,
      salePracticedInSaleRetail: null,
      isOfferInWhole: null,
      salePracticedTypeInWholeSale: null,
      salePracticedInWholeSale: null,
      isOfferInECommerce: null,
      salePriceTypePracticedInECommerce: null,
      salePracticedInECommerce: null,
    );
  }
}

extension BSFProductItemEntityToProductEntity on BSFProductItemEntity {
  ProductEntity toProductEntity(int? enterpriseCode) {
    final retailPracticedPrice = (priceCost?.saleRetailOfferPractice ?? 0) > 0
        ? (priceCost?.saleRetailOfferPractice ?? 0)
        : priceCost?.saleRetailPricePractice ?? 0;

    final wholePracticedPrice = (priceCost?.wholeSaleOfferPractice ?? 0) > 0
        ? (priceCost?.wholeSaleOfferPractice ?? 0)
        : priceCost?.wholeSalePricePractice ?? 0;

    final eCommercePracticedPrice = (priceCost?.eCommerceOfferPractice ?? 0) > 0
        ? (priceCost?.eCommerceOfferPractice ?? 0)
        : priceCost?.eCommercePricePractice ?? 0;

    return ProductEntity(
      EnterpriseCode: enterpriseCode,
      ProductCode: product?.code,
      ProductPackingCode: productPackingCode,
      PLU: product?.productPackingPriceLookUpString,
      Name: product?.name,
      PackingQuantity: product?.productPackingQuantity?.toString(),
      PackingAbbreviation: product?.productPackingTypeString,
      Value: retailPracticedPrice,
      RetailPracticedPrice: retailPracticedPrice,
      RetailSalePrice: priceCost?.saleRetailPricePractice,
      RetailOfferPrice: priceCost?.saleRetailOfferPractice,
      WholePracticedPrice: wholePracticedPrice,
      WholeSalePrice: priceCost?.wholeSalePricePractice,
      WholeOfferPrice: priceCost?.wholeSaleOfferPractice,
      MinimumWholeQuantity: priceCost?.mininumQuantityForWholeSale,
      ECommercePracticedPrice: eCommercePracticedPrice,
      ECommerceSalePrice: priceCost?.eCommercePricePractice,
      ECommerceOfferPrice: priceCost?.eCommerceOfferPractice,
      OperationalCost: priceCost?.operationCost,
      ReplacementCost: priceCost?.replacementCost,
      ReplacementCostMidle: priceCost?.mediumReplacementCost,
      LiquidCost: priceCost?.liquidCost,
      LiquidCostMidle: priceCost?.mediumLiquidCost,
      RealCost: priceCost?.replacementCostReal,
      RealLiquidCost: priceCost?.liquidCostReal,
      FiscalCost: priceCost?.replacementCostFiscal,
      FiscalLiquidCost: priceCost?.liquidCostFiscal,
      PriceCost: priceCost?.toPriceCostEntity(),
      BalanceLabelType: null,
      StorageAreaAddress: null,
      BalanceLabelQuantity: null,
      PendantPrintLabel: null,
      AlterationPriceForAllPackings: null,
      IsFatherOfGrate: product?.isFatherOfGrate,
      IsChildOfGrate: null,
      InClass: null,
      MarkUpdateClassInAdjustSalePriceIndividual: null,
      StockByEnterpriseAssociateds: null,
      Stocks: null,
      LastBuyEntrances: null,
      EANs: eanCode != null ? [eanCode!] : null,
      ResearchOfPriceCode: null,
      ConcurrentCode: null,
      codigoInternoProEmb: null,
      codigoProEmb: null,
      quantidadeInvContProEmb: null,
      FormatedProduct: null,
      Quantidade_ProcRecebDocProEmb: null,
      ReferenciaXml_ProcRecebDocProEmb: null,
      DataValidade_ProcRecebDocProEmb: null,
    );
  }
}

extension BSFPriceCostEntityToPriceCostEntity on BSFPriceCostEntity {
  PriceCostEntity toPriceCostEntity() {
    return PriceCostEntity(
      RetailPracticedPrice: saleRetailPricePractice,
      RetailSalePrice: saleRetailPricePractice,
      RetailOfferPrice: saleRetailOfferPractice,
      RetailSuggestionPrice: null,
      RetailMinimumPrice: null,
      WholePracticedPrice: wholeSalePricePractice,
      WholeSalePrice: wholeSalePricePractice,
      WholeOfferPrice: wholeSaleOfferPractice,
      WholeSuggestionPrice: null,
      WholeMinimumPrice: null,
      ECommercePracticedPrice: eCommercePricePractice,
      ECommerceSalePrice: eCommercePricePractice,
      ECommerceOfferPrice: eCommerceOfferPractice,
      ECommerceSuggestionPrice: null,
      ECommerceMinimumPrice: null,
      MinimumWholeQuantity: mininumQuantityForWholeSale,
      OperationalCost: operationCost,
      ReplacementCost: replacementCost,
      ReplacementCostMidle: mediumReplacementCost,
      LiquidCost: liquidCost,
      LiquidCostMidle: mediumLiquidCost,
      RealCost: replacementCostReal,
      RealLiquidCost: liquidCostReal,
      FiscalCost: replacementCostFiscal,
      FiscalLiquidCost: liquidCostFiscal,
      RetailMargin: null,
      RetailOfferMargin: null,
      RetailMinimumMargin: null,
      WholeMargin: null,
      WholeOfferMargin: null,
      WholeMinimumMargin: null,
      ECommerceMargin: null,
      ECommerceOfferMargin: null,
      ECommerceMinimumMargin: null,
    );
  }
}

extension CustomerEntityToBSFCustomerEntity on SoapCustomerEntity {
  BSFCustomerEntity toBSFCustomerEntity() {
    return BSFCustomerEntity(
      code: Code,
      personalizedCode: PersonalizedCode,
      name: Name,
      nameReduced: ReducedName,
      cnpjCpfNumber: CpfCnpjNumber,
      suframaCode: null,
      limitOfPurchase: null,
      inscriptionRgNumber: RegistrationNumber,
      paymentFinalizations: null,
      paymentConditions: null,
    );
  }
}
