import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcProductWithErrorSynchronizerErrorDetailModel
    extends EcProductWithErrorSynchronizerErrorDetailEntity {
  const EcProductWithErrorSynchronizerErrorDetailModel({
    required super.code,
    required super.enterpriseCode,
    required super.productPackingCode,
    required super.enterpriseCommerceSiteCode,
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

  factory EcProductWithErrorSynchronizerErrorDetailModel.fromJson(Map json) =>
      EcProductWithErrorSynchronizerErrorDetailModel(
        code: json['Code'] as int,
        enterpriseCode: json['EnterpriseCode'] as int,
        productPackingCode: json['ProductPackingCode'] as int,
        enterpriseCommerceSiteCode: json['EnterpriseCommerceSiteCode'] as int,
        enterprisePersonalizedCode:
            json['EnterprisePersonalizedCode'] as String,
        enterpriseFantasyName: json['EnterpriseFantasizesName'] as String,
        commerceSite: json['CommerceSite'] as String,
        priceLookUp: json['PriceLookUp'] as String,
        productName: json['ProductName'] as String,
        formattedPacking: json['FormattedPacking'] as String,
        productCommerceSiteId: json['ProductCommerceSiteId'] as String,
        errorDescription: json['ErrorDescription'] as String,
        errorMessage: json['ErrorMessage'] as String,
        moreInfo: json['MoreInfo'] as String,
        hasSendingRestriction: json['HasSendingRestriction'] as bool,
        lastChargeOfProduct: _date(json['LastChargeOfProduct']),
        lastChargeOfSalePrice: _date(json['LastChargeOfSalePrice']),
        lastChargeOfStock: _date(json['LastChargeOfStock']),
      );

  Map toJson() => {
    'Code': code,
    'EnterpriseCode': enterpriseCode,
    'ProductPackingCode': productPackingCode,
    'EnterpriseCommerceSiteCode': enterpriseCommerceSiteCode,
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'EnterpriseFantasizesName': enterpriseFantasyName,
    'CommerceSite': commerceSite,
    'PriceLookUp': priceLookUp,
    'ProductName': productName,
    'FormattedPacking': formattedPacking,
    'ProductCommerceSiteId': productCommerceSiteId,
    'ErrorDescription': errorDescription,
    'ErrorMessage': errorMessage,
    'MoreInfo': moreInfo,
    'HasSendingRestriction': hasSendingRestriction,
    'LastChargeOfProduct': lastChargeOfProduct?.toIso8601String(),
    'LastChargeOfSalePrice': lastChargeOfSalePrice?.toIso8601String(),
    'LastChargeOfStock': lastChargeOfStock?.toIso8601String(),
  };

  factory EcProductWithErrorSynchronizerErrorDetailModel.fromEntity(
    EcProductWithErrorSynchronizerErrorDetailEntity entity,
  ) => EcProductWithErrorSynchronizerErrorDetailModel(
    code: entity.code,
    enterpriseCode: entity.enterpriseCode,
    productPackingCode: entity.productPackingCode,
    enterpriseCommerceSiteCode: entity.enterpriseCommerceSiteCode,
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

  EcProductWithErrorSynchronizerErrorDetailEntity toEntity() =>
      EcProductWithErrorSynchronizerErrorDetailEntity(
        code: code,
        enterpriseCode: enterpriseCode,
        productPackingCode: productPackingCode,
        enterpriseCommerceSiteCode: enterpriseCommerceSiteCode,
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
