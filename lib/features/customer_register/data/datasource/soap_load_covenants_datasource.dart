import 'dart:convert';

import 'package:celta_intelligence/features/customer_register/data/models/covenant_model.dart';

import 'package:celta_intelligence/features/customer_register/domain/entities/search_covenant_type.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadCovenantsDatasource implements ISoapLoadCovenantsDatasource {
  final SoapRequest soapRequest;
  SoapLoadCovenantsDatasource(this.soapRequest);

  @override
  Future<List<CovenantModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required SearchCovenantType searchCovenantType,
    required String searchValue,
  }) async {
    //TODO create tests
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetCovenantJsonResponse",
      soapAction: "GetCovenantJson",
      serviceASMX: "CeltaCustomerService.asmx",
      typeOfResult: "GetCovenantJsonResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "covenantData": "%", //% to find everything
        "covenantDataType": searchCovenantType.code,
      },
    );

    return (json.decode(response) as List)
        .map((e) => CovenantModel.fromJson(e))
        .toList();
  }
}
