import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:equatable/equatable.dart';

class BSFRequestTypeEntity extends Equatable {
  final int? code;
  final String? name;
  final String? description;
  final String? observationsOnPrint;
  final String? personalizedCode;
  final int? type;
  final OperationType? operationType;
  final bool? generatePendencyFinancialTitle;
  final bool? allowAlterCostOrSalePrice;
  final bool? utilizeSaleLikePdvModel;
  final bool? insertProductAutomatically;
  final bool? allowsQuantityLikeProduct;
  final bool? groupProductsInSaleRequest;
  final int? decimalPlacesForUnitValue;
  final int? decimalPlacesForProductQuantity;
  final bool? allowUseDeliveryTax;
  final bool? allowUseIncrement;
  final bool? allowUseDiscount;
  final bool? allowDistribution;
  final bool? allowSaleOffer;
  final bool? considerAsStockPendency;
  final bool? showStockByClass;
  final bool? showStockByExtensibleGroup;
  final int? daysOfValidity;
  final bool? allowFinancialIncrement;
  final bool? allowFinancialDiscount;
  final dynamic userGroups;
  final List<BSFPaymentFinalizationEntity>? paymentFinalizations;
  final dynamic requestPrintEditionHeaderImage;
  final int? useWholePrice;
  final bool? useECommercePrice;
  final bool? allowSelectRequestTypeToAppRequests;
  final bool? allowSaleConvene;
  final PracticedPriceType? unitValueType;

  const BSFRequestTypeEntity({
    required this.code,
    required this.name,
    required this.description,
    required this.observationsOnPrint,
    required this.personalizedCode,
    required this.type,
    required this.operationType,
    required this.generatePendencyFinancialTitle,
    required this.allowAlterCostOrSalePrice,
    required this.utilizeSaleLikePdvModel,
    required this.insertProductAutomatically,
    required this.allowsQuantityLikeProduct,
    required this.groupProductsInSaleRequest,
    required this.decimalPlacesForUnitValue,
    required this.decimalPlacesForProductQuantity,
    required this.allowUseDeliveryTax,
    required this.allowUseIncrement,
    required this.allowUseDiscount,
    required this.allowDistribution,
    required this.allowSaleOffer,
    required this.considerAsStockPendency,
    required this.showStockByClass,
    required this.showStockByExtensibleGroup,
    required this.daysOfValidity,
    required this.allowFinancialIncrement,
    required this.allowFinancialDiscount,
    required this.userGroups,
    required this.paymentFinalizations,
    required this.requestPrintEditionHeaderImage,
    required this.useWholePrice,
    required this.useECommercePrice,
    required this.allowSelectRequestTypeToAppRequests,
    required this.allowSaleConvene,
    required this.unitValueType,
  });

  @override
  List<Object?> get props => [
    code,
    name,
    description,
    observationsOnPrint,
    personalizedCode,
    type,
    operationType,
    generatePendencyFinancialTitle,
    allowAlterCostOrSalePrice,
    utilizeSaleLikePdvModel,
    insertProductAutomatically,
    allowsQuantityLikeProduct,
    groupProductsInSaleRequest,
    decimalPlacesForUnitValue,
    decimalPlacesForProductQuantity,
    allowUseDeliveryTax,
    allowUseIncrement,
    allowUseDiscount,
    allowDistribution,
    allowSaleOffer,
    considerAsStockPendency,
    showStockByClass,
    showStockByExtensibleGroup,
    daysOfValidity,
    allowFinancialIncrement,
    allowFinancialDiscount,
    userGroups,
    paymentFinalizations,
    requestPrintEditionHeaderImage,
    useWholePrice,
    useECommercePrice,
    allowSelectRequestTypeToAppRequests,
    allowSaleConvene,
    unitValueType,
  ];

  BSFRequestTypeEntity copyWith({
    int? code,
    String? name,
    String? description,
    String? observationsOnPrint,
    String? personalizedCode,
    int? type,
    OperationType? operationType,
    bool? generatePendencyFinancialTitle,
    bool? allowAlterCostOrSalePrice,
    bool? utilizeSaleLikePdvModel,
    bool? insertProductAutomatically,
    bool? allowsQuantityLikeProduct,
    bool? groupProductsInSaleRequest,
    int? decimalPlacesForUnitValue,
    int? decimalPlacesForProductQuantity,
    bool? allowUseDeliveryTax,
    bool? allowUseIncrement,
    bool? allowUseDiscount,
    bool? allowDistribution,
    bool? allowSaleOffer,
    bool? considerAsStockPendency,
    bool? showStockByClass,
    bool? showStockByExtensibleGroup,
    int? daysOfValidity,
    bool? allowFinancialIncrement,
    bool? allowFinancialDiscount,
    dynamic userGroups,
    List<BSFPaymentFinalizationEntity>? paymentFinalizations,
    dynamic requestPrintEditionHeaderImage,
    int? useWholePrice,
    bool? useECommercePrice,
    bool? allowSelectRequestTypeToAppRequests,
    bool? allowSaleConvene,
    PracticedPriceType? unitValueType,
    bool? annulCode,
  }) {
    return BSFRequestTypeEntity(
      code: annulCode == true ? null : code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      observationsOnPrint: observationsOnPrint ?? this.observationsOnPrint,
      personalizedCode: personalizedCode ?? this.personalizedCode,
      type: type ?? this.type,
      operationType: operationType ?? this.operationType,
      generatePendencyFinancialTitle:
          generatePendencyFinancialTitle ?? this.generatePendencyFinancialTitle,
      allowAlterCostOrSalePrice:
          allowAlterCostOrSalePrice ?? this.allowAlterCostOrSalePrice,
      utilizeSaleLikePdvModel:
          utilizeSaleLikePdvModel ?? this.utilizeSaleLikePdvModel,
      insertProductAutomatically:
          insertProductAutomatically ?? this.insertProductAutomatically,
      allowsQuantityLikeProduct:
          allowsQuantityLikeProduct ?? this.allowsQuantityLikeProduct,
      groupProductsInSaleRequest:
          groupProductsInSaleRequest ?? this.groupProductsInSaleRequest,
      decimalPlacesForUnitValue:
          decimalPlacesForUnitValue ?? this.decimalPlacesForUnitValue,
      decimalPlacesForProductQuantity:
          decimalPlacesForProductQuantity ??
          this.decimalPlacesForProductQuantity,
      allowUseDeliveryTax: allowUseDeliveryTax ?? this.allowUseDeliveryTax,
      allowUseIncrement: allowUseIncrement ?? this.allowUseIncrement,
      allowUseDiscount: allowUseDiscount ?? this.allowUseDiscount,
      allowDistribution: allowDistribution ?? this.allowDistribution,
      allowSaleOffer: allowSaleOffer ?? this.allowSaleOffer,
      considerAsStockPendency:
          considerAsStockPendency ?? this.considerAsStockPendency,
      showStockByClass: showStockByClass ?? this.showStockByClass,
      showStockByExtensibleGroup:
          showStockByExtensibleGroup ?? this.showStockByExtensibleGroup,
      daysOfValidity: daysOfValidity ?? this.daysOfValidity,
      allowFinancialIncrement:
          allowFinancialIncrement ?? this.allowFinancialIncrement,
      allowFinancialDiscount:
          allowFinancialDiscount ?? this.allowFinancialDiscount,
      userGroups: userGroups ?? this.userGroups,
      paymentFinalizations: paymentFinalizations ?? this.paymentFinalizations,
      requestPrintEditionHeaderImage:
          requestPrintEditionHeaderImage ?? this.requestPrintEditionHeaderImage,
      useWholePrice: useWholePrice ?? this.useWholePrice,
      useECommercePrice: useECommercePrice ?? this.useECommercePrice,
      allowSelectRequestTypeToAppRequests:
          allowSelectRequestTypeToAppRequests ??
          this.allowSelectRequestTypeToAppRequests,
      allowSaleConvene: allowSaleConvene ?? this.allowSaleConvene,
      unitValueType: unitValueType ?? this.unitValueType,
    );
  }

  factory BSFRequestTypeEntity.empty() {
    return const BSFRequestTypeEntity(
      code: null,
      name: null,
      description: null,
      observationsOnPrint: null,
      personalizedCode: null,
      type: null,
      operationType: null,
      generatePendencyFinancialTitle: null,
      allowAlterCostOrSalePrice: null,
      utilizeSaleLikePdvModel: null,
      insertProductAutomatically: null,
      allowsQuantityLikeProduct: null,
      groupProductsInSaleRequest: null,
      decimalPlacesForUnitValue: null,
      decimalPlacesForProductQuantity: null,
      allowUseDeliveryTax: null,
      allowUseIncrement: null,
      allowUseDiscount: null,
      allowDistribution: null,
      allowSaleOffer: null,
      considerAsStockPendency: null,
      showStockByClass: null,
      showStockByExtensibleGroup: null,
      daysOfValidity: null,
      allowFinancialIncrement: null,
      allowFinancialDiscount: null,
      userGroups: null,
      paymentFinalizations: null,
      requestPrintEditionHeaderImage: null,
      useWholePrice: null,
      useECommercePrice: null,
      allowSelectRequestTypeToAppRequests: null,
      allowSaleConvene: null,
      unitValueType: null,
    );
  }
}
