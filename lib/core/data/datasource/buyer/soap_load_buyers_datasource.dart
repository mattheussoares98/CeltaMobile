import 'dart:convert';

import '../../../domain/contracts/contracts.dart';
import '../../models/models.dart';
import 'buyer.dart';

class SoapLoadBuyersDatasource implements ISoapLoadBuyersDatasource {
  final SoapRequest soapRequest;
  SoapLoadBuyersDatasource(this.soapRequest);

  @override
  Future<List<BuyerModel>> load({
    required String workingUrl,
    required String crossIdentity,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
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
