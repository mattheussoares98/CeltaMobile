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
  List<Object?> get props => [personalizedCode, name];
}
