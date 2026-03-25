import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

class BSFRequestTypeModel extends Equatable {
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

  const BSFRequestTypeModel({
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
    name,
    personalizedCode,
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

  factory BSFRequestTypeModel.fromJson(Map<String, dynamic> json) =>
      BSFRequestTypeModel(
        name: json['Name'],
        personalizedCode: json['PersonalizedCode'],
        allowAlterCostOrSalePrice: json['AllowAlterCostOrSalePrice'],
        utilizeSaleLikePdvModel: json['UtilizeSaleLikePdvModel'],
        allowUseDeliveryTax: json['AllowUseDeliveryTax'],
        allowUseIncrement: json['AllowUseIncrement'],
        allowUseDiscount: json['AllowUseDiscount'],
        allowDistribution: json['AllowDistribution'],
        allowSaleOffer: json['AllowSaleOffer'],
        considerAsStockPendency: json['ConsiderAsStockPendency'],
        showStockByClass: json['ShowStockByClass'],
        showStockByExtensibleGroup: json['ShowStockByExtensibleGroup'],
        daysOfValidity: json['DaysOfValidity'],
        userGroups: json['UserGroups'],
        paymentFinalizations: json['PaymentFinalizations'],
        requestPrintEditionHeaderImage: json['RequestPrintEditionHeaderImage'],
        useWholePrice: json['UseWholePrice'],
        useECommercePrice: json['UseECommercePrice'],
      );

  Map<String, dynamic> toJson() => {
    'Name': name,
    'PersonalizedCode': personalizedCode,
    'AllowAlterCostOrSalePrice': allowAlterCostOrSalePrice,
    'UtilizeSaleLikePdvModel': utilizeSaleLikePdvModel,
    'AllowUseDeliveryTax': allowUseDeliveryTax,
    'AllowUseIncrement': allowUseIncrement,
    'AllowUseDiscount': allowUseDiscount,
    'AllowDistribution': allowDistribution,
    'AllowSaleOffer': allowSaleOffer,
    'ConsiderAsStockPendency': considerAsStockPendency,
    'ShowStockByClass': showStockByClass,
    'ShowStockByExtensibleGroup': showStockByExtensibleGroup,
    'DaysOfValidity': daysOfValidity,
    'UserGroups': userGroups,
    'PaymentFinalizations': paymentFinalizations,
    'RequestPrintEditionHeaderImage': requestPrintEditionHeaderImage,
    'UseWholePrice': useWholePrice,
    'UseECommercePrice': useECommercePrice,
  };

  factory BSFRequestTypeModel.fromEntity(BSFRequestTypeEntity entity) =>
      BSFRequestTypeModel(
        name: entity.name,
        personalizedCode: entity.personalizedCode,
        allowAlterCostOrSalePrice: entity.allowAlterCostOrSalePrice,
        utilizeSaleLikePdvModel: entity.utilizeSaleLikePdvModel,
        allowUseDeliveryTax: entity.allowUseDeliveryTax,
        allowUseIncrement: entity.allowUseIncrement,
        allowUseDiscount: entity.allowUseDiscount,
        allowDistribution: entity.allowDistribution,
        allowSaleOffer: entity.allowSaleOffer,
        considerAsStockPendency: entity.considerAsStockPendency,
        showStockByClass: entity.showStockByClass,
        showStockByExtensibleGroup: entity.showStockByExtensibleGroup,
        daysOfValidity: entity.daysOfValidity,
        userGroups: entity.userGroups,
        paymentFinalizations: entity.paymentFinalizations,
        requestPrintEditionHeaderImage: entity.requestPrintEditionHeaderImage,
        useWholePrice: entity.useWholePrice,
        useECommercePrice: entity.useECommercePrice,
      );

  BSFRequestTypeEntity toEntity() => BSFRequestTypeEntity(
    name: name,
    personalizedCode: personalizedCode,
    allowAlterCostOrSalePrice: allowAlterCostOrSalePrice,
    utilizeSaleLikePdvModel: utilizeSaleLikePdvModel,
    allowUseDeliveryTax: allowUseDeliveryTax,
    allowUseIncrement: allowUseIncrement,
    allowUseDiscount: allowUseDiscount,
    allowDistribution: allowDistribution,
    allowSaleOffer: allowSaleOffer,
    considerAsStockPendency: considerAsStockPendency,
    showStockByClass: showStockByClass,
    showStockByExtensibleGroup: showStockByExtensibleGroup,
    daysOfValidity: daysOfValidity,
    userGroups: userGroups,
    paymentFinalizations: paymentFinalizations,
    requestPrintEditionHeaderImage: requestPrintEditionHeaderImage,
    useWholePrice: useWholePrice,
    useECommercePrice: useECommercePrice,
  );
}
