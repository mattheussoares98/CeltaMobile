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
        personalizedCode: null,
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
      quantity: 1.0,
      value: getPrice,
    );
  }
}

extension CustomerEntityToBSFCustomerEntity on CustomerEntity {
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
    );
  }
}
