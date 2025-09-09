import 'package:celta_intelligence/core/data/models/soap_enterprise_model.dart';

import '../../../domain/contracts/contracts.dart';
import '../datasource.dart';

class SoapEnterpriseDatasource implements ISoapEnterpriseDatasource {
  final SoapRequest soapAdapter;

  SoapEnterpriseDatasource({required this.soapAdapter});

  @override
  Future<List<SoapEnterpriseModel>> getEnterprises({
    required String url,
    required String crossIdentity,
  }) async {
    try {
      final response = await soapAdapter.post(
        url: url,
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

      return (response as List)
          .map((e) => SoapEnterpriseModel.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
