import 'dart:convert';

import '../../../domain/contracts/contracts.dart';
import '../../../domain/entities/entities.dart';
import '../datasource.dart';

class SoapResourceDatasource implements ISoapResourceDatasource {
  final SoapRequest soapAdapter;

  SoapResourceDatasource(this.soapAdapter);

  @override
  Future<bool> canAccessResource({
    required BsResource resource,
    required String baseUrl,
    required String crossIdentity,
    required BsRoutine routine,
  }) async {
    final response = await soapAdapter.post(
      url: baseUrl,
      parameters: {
        "jsonParameters": json.encode({
          "CrossIdentity": crossIdentity,
          "ResourceCode": resource.code,
          "RoutineInt": routine.code,
        }),
      },
      typeOfResponse: "UserCanAccessCrossResourceResponse",
      soapAction: "UserCanAccessCrossResource",
      serviceASMX: "CeltaSecurityService.asmx",
      typeOfResult: "UserCanAccessCrossResourceResult",
    );

    return json.decode(response)["CanAccess"] == true;
  }
}
