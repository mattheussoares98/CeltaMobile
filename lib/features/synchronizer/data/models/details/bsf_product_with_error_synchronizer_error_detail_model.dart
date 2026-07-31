import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

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
            json['EnterprisePersonalizedCode'] as String,
        enterpriseFantasyName: json['EnterpriseFantasizesName'] as String,
        commerceSite: json['CommerceSite'] as String,
        priceLookUp: json['PriceLookUp'] as String,
        productName: json['ProductName'] as String,
        formattedPacking: json['FormattedPacking'] as String,
        productCommerceSiteId: json['ProductCommerceSiteId'] as String,
        errorDescription: json['Errordescription'] as String,
        errorMessage: json['ErrorMessage'] as String,
        moreInfo: json['MoreInfo'] as String,
        hasSendingRestriction: json['HasSendingRestriction'] as bool,
        lastChargeOfProduct: _date(json['LastChargeOfProduct']),
        lastChargeOfSalePrice: _date(json['LastChargeOfSalePrice']),
        lastChargeOfStock: _date(json['LastChargeOfStock']),
      );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'EnterpriseFantasizesName': enterpriseFantasyName,
    'CommerceSite': commerceSite,
    'PriceLookUp': priceLookUp,
    'ProductName': productName,
    'FormattedPacking': formattedPacking,
    'ProductCommerceSiteId': productCommerceSiteId,
    'Errordescription': errorDescription,
    'ErrorMessage': errorMessage,
    'MoreInfo': moreInfo,
    'HasSendingRestriction': hasSendingRestriction,
    'LastChargeOfProduct': lastChargeOfProduct?.toIso8601String(),
    'LastChargeOfSalePrice': lastChargeOfSalePrice?.toIso8601String(),
    'LastChargeOfStock': lastChargeOfStock?.toIso8601String(),
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
