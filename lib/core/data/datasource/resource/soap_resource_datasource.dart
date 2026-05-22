import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/datasource/resource/resource.dart';

class SoapResourceDatasource implements ISoapResourceDatasource {
  final SoapRequest soapAdapter;

  SoapResourceDatasource(this.soapAdapter);

  @override
  Future<bool> canAccessResource({
    required BsResource resource,
    required String workingUrl,
    required String crossIdentity,
    required BsRoutine routine,
  }) async {
    final response = await soapAdapter.post(
      url: workingUrl,
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
