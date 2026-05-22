import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/data/datasource/bs_version/bs_version.dart';

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
