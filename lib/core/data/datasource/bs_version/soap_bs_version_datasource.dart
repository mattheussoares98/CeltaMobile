import 'dart:convert';

import '../../../domain/contracts/contracts.dart';
import 'bs_version.dart';

class SoapBsVersionDatasource implements ISoapBsVersionDatasource {
  final SoapRequest soapRequest;
  SoapBsVersionDatasource(this.soapRequest);

  @override
  Future<DateTime> get(String workingUrl) async {
    final response = await soapRequest.post(
      url: workingUrl,
      parameters: {},
      typeOfResponse: "GetVersionDateResponse",
      soapAction: "GetVersionDate",
      serviceASMX: "CeltaSecurityService.asmx",
      typeOfResult: "GetVersionDateResult",
    );

    return DateTime.parse((json.decode(response))["VersionDate"]);
  }
}
