import 'dart:convert';

import 'package:celta_intelligence/core/data/models/soap_enterprise_model.dart';

import '../../../domain/contracts/contracts.dart';
import '../datasource.dart';

class SoapEnterpriseDataSource implements ISoapEnterpriseDataSource {
  final SoapRequest soapAdapter;

  SoapEnterpriseDataSource({required this.soapAdapter});

  @override
  Future<List<SoapEnterpriseModel>> getEnterprises({
    required String baseUrl,
    required String crossIdentity,
  }) async {
    try {
      final response = await soapAdapter.post(
        url: baseUrl,
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
    } catch (e) {
      rethrow;
    }
  }
}
