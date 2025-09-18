import 'dart:convert';

import 'package:celta_intelligence/core/data/models/soap_enterprise_model.dart';
import 'package:celta_intelligence/utils/utils.dart';

import '../../../domain/contracts/contracts.dart';
import '../datasource.dart';

class SoapEnterpriseDatasource implements ISoapEnterpriseDatasource {
  final SoapRequest soapAdapter;

  SoapEnterpriseDatasource({required this.soapAdapter});

  @override
  Future<List<SoapEnterpriseModel>> getEnterprises({
    required String baseUrl,
    required String crossIdentity,
  }) async {
    final response = await soapAdapter.post(
      url: baseUrl.toLowerCase().removeWhiteSpaces(),
      parameters: {
        "crossIdentity": crossIdentity,
        "simpleSearchValue": "",
        "requestTypeCode": 0,
      },
      soapAction: "GetEnterprisesJson",
      typeOfResponse: "GetEnterprisesJsonResponse",
      serviceASMX: "celtaenterpriseService.asmx",
      typeOfResult: "GetEnterprisesJsonResult",
    );

    return (json.decode(response) as List)
        .map((e) => SoapEnterpriseModel.fromJson(e))
        .toList();
  }
}
