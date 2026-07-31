import 'Package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'Package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

class BSFSaleRequestWithErrorSynchronizerErrorDetailModel
    extends BSFSaleRequestWithErrorSynchronizerErrorDetailEntity {
  const BSFSaleRequestWithErrorSynchronizerErrorDetailModel({
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

  factory BSFSaleRequestWithErrorSynchronizerErrorDetailModel.fromJson(
    Map json,
  ) => BSFSaleRequestWithErrorSynchronizerErrorDetailModel(
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
              BSFSaleRequestProductNotFoundDetailModel.fromJson(item as Map),
        )
        .toList(),
  );

  Map toJson() => {
    'EnterprisePersonalizedCode': enterprisePersonalizedCode,
    'CreationDate': creationDate.toIso8601String(),
    'CadasterDate': cadasterDate.toIso8601String(),
    'CommerceSite': commerceSite,
    'SaleRequestInvoiceCode': saleRequestInvoiceCode,
    'SaleRequestNumber': saleRequestNumber,
    'CommerceSiteFile': commerceSiteFile,
    'Details': details,
    'ProductsNotFound': productsNotFound
        .map(BSFSaleRequestProductNotFoundDetailModel.fromEntity)
        .map((model) => model.toJson())
        .toList(),
  };

  factory BSFSaleRequestWithErrorSynchronizerErrorDetailModel.fromEntity(
    BSFSaleRequestWithErrorSynchronizerErrorDetailEntity entity,
  ) => BSFSaleRequestWithErrorSynchronizerErrorDetailModel(
    enterprisePersonalizedCode: entity.enterprisePersonalizedCode,
    creationDate: entity.creationDate,
    cadasterDate: entity.cadasterDate,
    commerceSite: entity.commerceSite,
    saleRequestInvoiceCode: entity.saleRequestInvoiceCode,
    saleRequestNumber: entity.saleRequestNumber,
    commerceSiteFile: entity.commerceSiteFile,
    details: entity.details,
    productsNotFound: entity.productsNotFound
        .map(BSFSaleRequestProductNotFoundDetailModel.fromEntity)
        .toList(),
  );

  BSFSaleRequestWithErrorSynchronizerErrorDetailEntity toEntity() =>
      BSFSaleRequestWithErrorSynchronizerErrorDetailEntity(
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
              (item) => BSFSaleRequestProductNotFoundDetailModel.fromEntity(
                item,
              ).toEntity(),
            )
            .toList(),
      );
}
