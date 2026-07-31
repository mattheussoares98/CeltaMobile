import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

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
    enterprisePersonalizedCode: json['enterprisePersonalizedCode'] as String,
    creationDate: DateTime.parse(json['creationDate'] as String),
    cadasterDate: DateTime.parse(json['cadasterDate'] as String),
    commerceSite: json['commerceSite'] as String,
    saleRequestInvoiceCode: json['saleRequestInvoiceCode'] as String,
    saleRequestNumber: json['saleRequestNumber'] as String,
    commerceSiteFile: json['commerceSiteFile'] as String,
    details: List<String>.from(json['details'] as List),
    productsNotFound: (json['productsNotFound'] as List)
        .map(
          (item) =>
              BSFSaleRequestProductNotFoundDetailModel.fromJson(item as Map),
        )
        .toList(),
  );

  Map toJson() => {
    'enterprisePersonalizedCode': enterprisePersonalizedCode,
    'creationDate': creationDate.toIso8601String(),
    'cadasterDate': cadasterDate.toIso8601String(),
    'commerceSite': commerceSite,
    'saleRequestInvoiceCode': saleRequestInvoiceCode,
    'saleRequestNumber': saleRequestNumber,
    'commerceSiteFile': commerceSiteFile,
    'details': details,
    'productsNotFound': productsNotFound
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
