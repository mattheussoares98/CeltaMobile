import 'package:equatable/equatable.dart';

class BSFRequestTypeEntity extends Equatable {
  final String? name;
  final String? personalizedCode;
  final bool? allowAlterCostOrSalePrice;
  final bool? utilizeSaleLikePdvModel;
  final bool? allowUseDeliveryTax;
  final bool? allowUseIncrement;
  final bool? allowUseDiscount;
  final bool? allowDistribution;
  final bool? allowSaleOffer;
  final bool? considerAsStockPendency;
  final bool? showStockByClass;
  final bool? showStockByExtensibleGroup;
  final int? daysOfValidity;
  final dynamic userGroups;
  final List<dynamic>? paymentFinalizations;
  final dynamic requestPrintEditionHeaderImage;
  final int? useWholePrice;
  final bool? useECommercePrice;

  const BSFRequestTypeEntity({
    required this.name,
    required this.personalizedCode,
    required this.allowAlterCostOrSalePrice,
    required this.utilizeSaleLikePdvModel,
    required this.allowUseDeliveryTax,
    required this.allowUseIncrement,
    required this.allowUseDiscount,
    required this.allowDistribution,
    required this.allowSaleOffer,
    required this.considerAsStockPendency,
    required this.showStockByClass,
    required this.showStockByExtensibleGroup,
    required this.daysOfValidity,
    required this.userGroups,
    required this.paymentFinalizations,
    required this.requestPrintEditionHeaderImage,
    required this.useWholePrice,
    required this.useECommercePrice,
  });

  @override
  List<Object?> get props => [
    personalizedCode,
    name,
    allowAlterCostOrSalePrice,
    utilizeSaleLikePdvModel,
    allowUseDeliveryTax,
    allowUseIncrement,
    allowUseDiscount,
    allowDistribution,
    allowSaleOffer,
    considerAsStockPendency,
    showStockByClass,
    showStockByExtensibleGroup,
    daysOfValidity,
    userGroups,
    paymentFinalizations,
    requestPrintEditionHeaderImage,
    useWholePrice,
    useECommercePrice,
  ];

  BSFRequestTypeEntity copyWith({
    String? name,
    String? personalizedCode,
    bool? allowAlterCostOrSalePrice,
    bool? utilizeSaleLikePdvModel,
    bool? allowUseDeliveryTax,
    bool? allowUseIncrement,
    bool? allowUseDiscount,
    bool? allowDistribution,
    bool? allowSaleOffer,
    bool? considerAsStockPendency,
    bool? showStockByClass,
    bool? showStockByExtensibleGroup,
    int? daysOfValidity,
    dynamic userGroups,
    List<dynamic>? paymentFinalizations,
    dynamic requestPrintEditionHeaderImage,
    int? useWholePrice,
    bool? useECommercePrice,
  }) {
    return BSFRequestTypeEntity(
      name: name ?? this.name,
      personalizedCode: personalizedCode ?? this.personalizedCode,
      allowAlterCostOrSalePrice:
          allowAlterCostOrSalePrice ?? this.allowAlterCostOrSalePrice,
      utilizeSaleLikePdvModel:
          utilizeSaleLikePdvModel ?? this.utilizeSaleLikePdvModel,
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
      userGroups: userGroups ?? this.userGroups,
      paymentFinalizations: paymentFinalizations ?? this.paymentFinalizations,
      requestPrintEditionHeaderImage:
          requestPrintEditionHeaderImage ?? this.requestPrintEditionHeaderImage,
      useWholePrice: useWholePrice ?? this.useWholePrice,
      useECommercePrice: useECommercePrice ?? this.useECommercePrice,
    );
  }

  factory BSFRequestTypeEntity.empty() {
    return const BSFRequestTypeEntity(
      name: null,
      personalizedCode: null,
      allowAlterCostOrSalePrice: null,
      utilizeSaleLikePdvModel: null,
      allowUseDeliveryTax: null,
      allowUseIncrement: null,
      allowUseDiscount: null,
      allowDistribution: null,
      allowSaleOffer: null,
      considerAsStockPendency: null,
      showStockByClass: null,
      showStockByExtensibleGroup: null,
      daysOfValidity: null,
      userGroups: null,
      paymentFinalizations: null,
      requestPrintEditionHeaderImage: null,
      useWholePrice: null,
      useECommercePrice: null,
    );
  }
}
