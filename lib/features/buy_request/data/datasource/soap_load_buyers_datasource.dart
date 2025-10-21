import 'dart:convert';

import 'package:celta_intelligence/features/buy_request/data/models/buyer_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadBuyersDatasource implements ISoapLoadBuyersDatasource {
  final SoapRequest soapRequest;
  SoapLoadBuyersDatasource(this.soapRequest);

  @override
  Future<List<BuyerModel>> load({
    required String baseUrl,
    required String crossIdentity,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetEmployeeJsonResponse",
      soapAction: "GetEmployeeJson",
      serviceASMX: "CeltaEmployeeService.asmx",
      typeOfResult: "GetEmployeeJsonResult",
      parameters: {
        "filters": json.encode({
          "CrossIdentity": crossIdentity,
          "RoutineInt": 2,
        }),
      },
    );

    return (json.decode(response) as List)
        .map((e) => BuyerModel.fromJson(e))
        .toList();
  }
}
