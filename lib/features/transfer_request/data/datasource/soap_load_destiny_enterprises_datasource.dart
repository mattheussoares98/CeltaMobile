import 'dart:convert';

import 'package:celta_intelligence/core/data/models/enterprise/soap_enterprise_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadDestinyEnterprisesDatasource
    implements ISoapLoadDestinyEnterprisesDatasource {
  final SoapRequest soapRequest;
  SoapLoadDestinyEnterprisesDatasource(this.soapRequest);

  @override
  Future<List<SoapEnterpriseModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int requestTypeCode,
    required int enterpriseOriginCode,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetEnterprisesDestinyJsonResponse",
      soapAction: "GetEnterprisesDestinyJson",
      serviceASMX: "CeltaEnterpriseService.asmx",
      typeOfResult: "GetEnterprisesDestinyJsonResult",
      parameters: {
        "crossIdentity": crossIdentity,
        "requestTypeCode": requestTypeCode,
        "enterpriseOriginCode": enterpriseOriginCode,
      },
    );

    return (json.decode(response) as List)
        .map((e) => SoapEnterpriseModel.fromJson(e))
        .toList();
  }
}
