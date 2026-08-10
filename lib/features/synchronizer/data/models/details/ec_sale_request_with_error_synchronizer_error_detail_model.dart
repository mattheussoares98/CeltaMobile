import 'Package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class EcSaleRequestWithErrorSynchronizerErrorDetailModel
    extends EcSaleRequestWithErrorSynchronizerErrorDetailEntity {
  const EcSaleRequestWithErrorSynchronizerErrorDetailModel({
    required super.code,
    required super.enterprisePersonalizedCode,
    required super.creationDate,
    required super.cadasterDate,
    required super.commerceSite,
    required super.saleRequestInvoiceCode,
    required super.saleRequestNumber,
    required super.commerceSiteFile,
    required super.details,
    required super.productsNotFound,
  });

  factory EcSaleRequestWithErrorSynchronizerErrorDetailModel.fromJson(
    Map json,
  ) => EcSaleRequestWithErrorSynchronizerErrorDetailModel(
    code: json['Code'] as int,
    enterprisePersonalizedCode: json['EnterprisePersonalizedCode'] as String,
    creationDate: DateTime.parse(json['CreationDate'] as String),
    cadasterDate: DateTime.parse(json['CadasterDate'] as String),
    commerceSite: json['CommerceSite'] as String,
    saleRequestInvoiceCode: json['SaleRequestInvoiceCode'] as String,
    saleRequestNumber: json['SaleRequestNumber'] as String,
    commerceSiteFile: json['CommerceSiteFile'] as String,
    details: List<String>.from(json['Details'] as List),
    productsNotFound: (json['ProductsNotFound'] as List)
        .map(
          (item) =>
              EcSaleRequestProductNotFoundDetailModel.fromJson(item as Map),
        )
        .toList(),
  );

  Map toJson() => {
    'Code': code,
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'CadasterDate': cadasterDate.toIso8601String(),
    'CommerceSite': commerceSite,
    'SaleRequestInvoiceCode': saleRequestInvoiceCode,
    'SaleRequestNumber': saleRequestNumber,
    'CommerceSiteFile': commerceSiteFile,
    'Details': details,
    'ProductsNotFound': productsNotFound
        .map(EcSaleRequestProductNotFoundDetailModel.fromEntity)
        .map((model) => model.toJson())
        .toList(),
  };

  factory EcSaleRequestWithErrorSynchronizerErrorDetailModel.fromEntity(
    EcSaleRequestWithErrorSynchronizerErrorDetailEntity entity,
  ) => EcSaleRequestWithErrorSynchronizerErrorDetailModel(
    code: entity.code,
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    cadasterDate: entity.cadasterDate,
    commerceSite: entity.commerceSite,
    saleRequestInvoiceCode: entity.saleRequestInvoiceCode,
    saleRequestNumber: entity.saleRequestNumber,
    commerceSiteFile: entity.commerceSiteFile,
    details: entity.details,
    productsNotFound: entity.productsNotFound
        .map(EcSaleRequestProductNotFoundDetailModel.fromEntity)
        .toList(),
  );

  EcSaleRequestWithErrorSynchronizerErrorDetailEntity toEntity() =>
      EcSaleRequestWithErrorSynchronizerErrorDetailEntity(
        code: code,
        enterprisePersonalizedCode: enterprisePersonalizedCode,
        creationDate: creationDate,
        cadasterDate: cadasterDate,
        commerceSite: commerceSite,
        saleRequestInvoiceCode: saleRequestInvoiceCode,
        saleRequestNumber: saleRequestNumber,
        commerceSiteFile: commerceSiteFile,
        details: details,
        productsNotFound: productsNotFound
            .map(
              (item) => EcSaleRequestProductNotFoundDetailModel.fromEntity(
                item,
              ).toEntity(),
            )
            .toList(),
      );
}
