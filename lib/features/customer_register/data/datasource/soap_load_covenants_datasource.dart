import 'dart:convert';

import 'package:celta_inventario/features/customer_register/data/models/covenant_model.dart';

import 'package:celta_inventario/features/customer_register/domain/entities/search_covenant_type.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadCovenantsDatasource implements ISoapLoadCovenantsDatasource {
  final SoapRequest soapRequest;
  SoapLoadCovenantsDatasource(this.soapRequest);

  @override
  Future<List<CovenantModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required SearchCovenantType searchCovenantType,
    required String searchValue,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "GetCovenantJsonResponse",
      soapAction: "GetCovenantJson",
      serviceASMX: "CeltaCustomerService.asmx",
      typeOfResult: "GetCovenantJsonResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "covenantData": searchValue, //% to find everything
        "covenantDataType": searchCovenantType.code,
      },
    );

    return (json.decode(response) as List)
        .map((e) => CovenantModel.fromJson(e))
        .toList();
  }
}
