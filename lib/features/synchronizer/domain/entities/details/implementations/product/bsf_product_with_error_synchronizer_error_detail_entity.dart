import 'package:celta_inventario/features/synchronizer/domain/entities/details/details.dart';

class BSFProductWithErrorSynchronizerErrorDetailEntity
    extends SynchronizerErrorDetailEntity {
  final String enterprisePersonalizedCode;
  final String enterpriseFantasyName;
  final String commerceSite;
  final String priceLookUp;
  final String productName;
  final String formattedPacking;
  final String productCommerceSiteId;
  final String errorDescription;
  final String errorMessage;
  final String moreInfo;
  final bool hasSendingRestriction;
  final DateTime? lastChargeOfProduct;
  final DateTime? lastChargeOfSalePrice;
  final DateTime? lastChargeOfStock;

  const BSFProductWithErrorSynchronizerErrorDetailEntity({
    required this.enterprisePersonalizedCode,
    required this.enterpriseFantasyName,
    required this.commerceSite,
    required this.priceLookUp,
    required this.productName,
    required this.formattedPacking,
    required this.productCommerceSiteId,
    required this.errorDescription,
    required this.errorMessage,
    required this.moreInfo,
    required this.hasSendingRestriction,
    required this.lastChargeOfProduct,
    required this.lastChargeOfSalePrice,
    required this.lastChargeOfStock,
  });

  @override
  List<Object?> get props => [
    enterprisePersonalizedCode,
    enterpriseFantasyName,
    commerceSite,
    priceLookUp,
    productName,
    formattedPacking,
    productCommerceSiteId,
    errorDescription,
    errorMessage,
    moreInfo,
    hasSendingRestriction,
    lastChargeOfProduct,
    lastChargeOfSalePrice,
    lastChargeOfStock,
  ];
}
