import 'dart:convert';

import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/transfer_request/data/models/models.dart';
import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';

class SoapInsertTransferRequestDatasource
    implements ISoapInsertTransferRequestDatasource {
  final SoapRequest soapRequest;
  SoapInsertTransferRequestDatasource(this.soapRequest);

  @override
  Future<String> save({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
    required List<TransferRequestProductItemModel> products,
  }) async {
    final updatedProducts = products.map((e) {
      final entityWithNewValue = e.product.toEntity().copyWith(Value: e.value);
      final json = ProductModel.fromEntity(entityWithNewValue).toJson();
      json.addAll({'quantity': e.quantity});

      return json;
    }).toList();

    return await soapRequest.post(
      url: workingUrl,
      typeOfResult: null,
      typeOfResponse: "InsertResponse",
      soapAction: "Insert",
      serviceASMX: "CeltaTransferRequestService.asmx",
      parameters: {
        "crossIdentity": crossIdentity,
        "json": json.encode({
          "crossId": crossIdentity,
          "EnterpriseOriginCode": enterpriseOriginCode,
          "EnterpriseDestinyCode": enterpriseDestinyCode,
          "RequestTypeCode": requestTypeCode,
          "Products": updatedProducts,
        }),
      },
    );
  }
}
