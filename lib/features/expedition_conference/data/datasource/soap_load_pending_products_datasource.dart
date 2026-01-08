import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import '../models/models.dart';
import 'datasource.dart';

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
