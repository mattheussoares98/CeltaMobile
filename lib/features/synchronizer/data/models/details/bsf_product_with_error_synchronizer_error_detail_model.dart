import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFProductWithErrorSynchronizerErrorDetailModel
    extends BSFProductWithErrorSynchronizerErrorDetailEntity {
  const BSFProductWithErrorSynchronizerErrorDetailModel({
    required super.enterprisePersonalizedCode,
    required super.enterpriseFantasyName,
    required super.commerceSite,
    required super.priceLookUp,
    required super.productName,
    required super.formattedPacking,
    required super.productCommerceSiteId,
    required super.errorDescription,
    required super.errorMessage,
    required super.moreInfo,
    required super.hasSendingRestriction,
    required super.lastChargeOfProduct,
    required super.lastChargeOfSalePrice,
    required super.lastChargeOfStock,
  });

  factory BSFProductWithErrorSynchronizerErrorDetailModel.fromJson(Map json) =>
      BSFProductWithErrorSynchronizerErrorDetailModel(
        enterprisePersonalizedCode:
            json['enterprisePersonalizedCode'] as String,
        enterpriseFantasyName: json['enterpriseFantasizesName'] as String,
        commerceSite: json['commerceSite'] as String,
        priceLookUp: json['priceLookUp'] as String,
        productName: json['productName'] as String,
        formattedPacking: json['formattedPacking'] as String,
        productCommerceSiteId: json['productCommerceSiteId'] as String,
        errorDescription: json['errordescription'] as String,
        errorMessage: json['errorMessage'] as String,
        moreInfo: json['moreInfo'] as String,
        hasSendingRestriction: json['hasSendingRestriction'] as bool,
        lastChargeOfProduct: _date(json['lastChargeOfProduct']),
        lastChargeOfSalePrice: _date(json['lastChargeOfSalePrice']),
        lastChargeOfStock: _date(json['lastChargeOfStock']),
      );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'enterpriseFantasizesName': enterpriseFantasyName,
    'commerceSite': commerceSite,
    'priceLookUp': priceLookUp,
    'productName': productName,
    'formattedPacking': formattedPacking,
    'productCommerceSiteId': productCommerceSiteId,
    'errordescription': errorDescription,
    'errorMessage': errorMessage,
    'moreInfo': moreInfo,
    'hasSendingRestriction': hasSendingRestriction,
    'lastChargeOfProduct': lastChargeOfProduct?.toIso8601String(),
    'lastChargeOfSalePrice': lastChargeOfSalePrice?.toIso8601String(),
    'lastChargeOfStock': lastChargeOfStock?.toIso8601String(),
  };

  factory BSFProductWithErrorSynchronizerErrorDetailModel.fromEntity(
    BSFProductWithErrorSynchronizerErrorDetailEntity entity,
  ) => BSFProductWithErrorSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    enterpriseFantasyName: entity.enterpriseFantasyName,
    commerceSite: entity.commerceSite,
    priceLookUp: entity.priceLookUp,
    productName: entity.productName,
    formattedPacking: entity.formattedPacking,
    productCommerceSiteId: entity.productCommerceSiteId,
    errorDescription: entity.errorDescription,
    errorMessage: entity.errorMessage,
    moreInfo: entity.moreInfo,
    hasSendingRestriction: entity.hasSendingRestriction,
    lastChargeOfProduct: entity.lastChargeOfProduct,
    lastChargeOfSalePrice: entity.lastChargeOfSalePrice,
    lastChargeOfStock: entity.lastChargeOfStock,
  );

  BSFProductWithErrorSynchronizerErrorDetailEntity toEntity() =>
      BSFProductWithErrorSynchronizerErrorDetailEntity(
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        enterpriseFantasyName: enterpriseFantasyName,
        commerceSite: commerceSite,
        priceLookUp: priceLookUp,
        productName: productName,
        formattedPacking: formattedPacking,
        productCommerceSiteId: productCommerceSiteId,
        errorDescription: errorDescription,
        errorMessage: errorMessage,
        moreInfo: moreInfo,
        hasSendingRestriction: hasSendingRestriction,
        lastChargeOfProduct: lastChargeOfProduct,
        lastChargeOfSalePrice: lastChargeOfSalePrice,
        lastChargeOfStock: lastChargeOfStock,
      );

  static DateTime? _date(Object? value) =>
      value == null ? null : DateTime.parse(value as String);
}
