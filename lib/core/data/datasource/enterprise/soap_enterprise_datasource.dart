import 'dart:convert';

import 'package:celta_inventario/core/data/models/enterprise/soap_enterprise_model.dart';
import 'package:celta_inventario/utils/utils.dart';

import '../../../domain/contracts/contracts.dart';
import 'enterprise.dart';

class SoapEnterpriseDatasource implements ISoapEnterpriseDatasource {
  final SoapRequest soapAdapter;

  SoapEnterpriseDatasource({required this.soapAdapter});

  @override
  Future<List<SoapEnterpriseModel>> getEnterprises({
    required String workingUrl,
    required String crossIdentity,
    int? enterpriseOriginCode,
    int? requestTypeCode,
  }) async {
    final parameters = <String, dynamic>{
      "crossIdentity": crossIdentity,
      "simpleSearchValue": "",
    };
    parameters.addAll({
      "enterpriseOriginCode": ?enterpriseOriginCode,
      "requestTypeCode": ?requestTypeCode,
    });

    final response = await soapAdapter.post(
      url: workingUrl.toLowerCase().removeWhiteSpaces(),
      parameters: parameters,
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
