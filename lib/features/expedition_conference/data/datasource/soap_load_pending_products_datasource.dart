import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/expedition_conference/data/models/models.dart';
import 'package:celta_inventario/features/expedition_conference/data/datasource/datasource.dart';

class SoapLoadPendingProductsDatasource
    implements ISoapLoadPendingProductsDatasource {
  final SoapRequest soapRequest;

  SoapLoadPendingProductsDatasource(this.soapRequest);

  @override
  Future<List<ExpeditionProductModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int expeditionControlCode,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "GetExpeditionControlProductsResponse",
      soapAction: "GetExpeditionControlProducts",
      serviceASMX: "CeltaProductService.asmx",
      typeOfResult: "GetExpeditionControlProductsResult",
      parameters: {
        "stringFilters": json.encode({
          "CrossIdentity": crossIdentity,
          "ExpeditionControlCode": expeditionControlCode,
        }),
      },
    );

    return (json.decode(response) as List)
        .map((e) => ExpeditionProductModel.fromJson(e))
        .toList();
  }
}
