import 'package:equatable/equatable.dart';

class EcCompleteRequestTypeModel extends Equatable {
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

  const EcCompleteRequestTypeModel({
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

  factory EcCompleteRequestTypeModel.fromJson(Map<String, dynamic> json) =>
      EcCompleteRequestTypeModel(
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

  @override
  List<Object?> get props => [personalizedCode, name];
}
