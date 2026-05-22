import 'dart:convert';

import 'package:celta_inventario/core/data/models/request_type/request_type_model.dart';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/datasource/request_type/request_type.dart';

class SoapLoadRequestTypeDatasource implements ISoapLoadRequestTypeDatasource {
  final SoapRequest soapRequest;
  SoapLoadRequestTypeDatasource(this.soapRequest);

  @override
  Future<List<RequestTypeModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required bool inclusiveBuy,
    required bool inclusiveTransfer,
    required bool inclusiveSale,
    required int enterpriseCode,
  }) async {
    final result = await soapRequest.post(
      url: workingUrl,
      serviceASMX: "CeltaRequestTypeService.asmx",
      typeOfResponse: "GetRequestTypesJsonResponse",
      soapAction: "GetRequestTypesJson",
      typeOfResult: "GetRequestTypesJsonResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "inclusiveBuy": inclusiveBuy,
        "inclusiveTransfer": inclusiveTransfer,
        "inclusiveSale": inclusiveSale,
        "enterpriseCode": enterpriseCode,
      },
    );

    return (json.decode(result) as List)
        .map((e) => RequestTypeModel.fromJson(e))
        .toList();
  }
}
