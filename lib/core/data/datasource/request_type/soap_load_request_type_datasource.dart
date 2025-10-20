import 'dart:convert';

import 'package:celta_intelligence/core/data/models/request_type/request_type_model.dart';

import '../../../domain/contracts/contracts.dart';
import 'request_type.dart';

class SoapLoadRequestTypeDatasource implements ISoapLoadRequestTypeDatasource {
  final SoapRequest soapRequest;
  SoapLoadRequestTypeDatasource(this.soapRequest);

  @override
  Future<List<RequestTypeModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required bool inclusiveBuy,
    required bool inclusiveTransfer,
    required bool inclusiveSale,
  }) async {
    final result = await soapRequest.post(
      url: baseUrl,
      serviceASMX: "CeltaRequestTypeService.asmx",
      typeOfResponse: "GetRequestTypesJsonResponse",
      soapAction: "GetRequestTypesJson",
      typeOfResult: "GetRequestTypesJsonResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "inclusiveBuy": inclusiveBuy,
        "inclusiveTransfer": inclusiveTransfer,
        "inclusiveSale": inclusiveSale,
      },
    );

    return (json.decode(result) as List)
        .map((e) => RequestTypeModel.fromJson(e))
        .toList();
  }
}
