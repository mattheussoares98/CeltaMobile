import 'dart:convert';

import 'package:celta_inventario/core/data/models/enterprise/soap_enterprise_model.dart';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/transfer_request/data/datasource/datasource.dart';

class SoapLoadDestinyEnterprisesDatasource
    implements ISoapLoadDestinyEnterprisesDatasource {
  final SoapRequest soapRequest;
  SoapLoadDestinyEnterprisesDatasource(this.soapRequest);

  @override
  Future<List<SoapEnterpriseModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int requestTypeCode,
    required int enterpriseOriginCode,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
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
