import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/expedition_conference/data/datasource/datasource.dart';

class SoapConfirmConferenceDatasource
    implements ISoapConfirmConferenceDatasource {
  final SoapRequest soapRequest;
  SoapConfirmConferenceDatasource(this.soapRequest);

  @override
  Future<void> confirm({
    required String workingUrl,
    required String crossIdentity,
    required int expeditionControlCode,
    required int stepCode,
  }) async {
    await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "ConfirmConferenceResponse",
      soapAction: "ConfirmConference",
      serviceASMX: "CeltaProductService.asmx",
      typeOfResult: null,
      parameters: {
        "parametersString": json.encode({
          "CrossIdentity": crossIdentity,
          "ExpeditionControlCode": expeditionControlCode,
          "StepCode": stepCode,
          "Confered": true,
        }),
      },
    );
  }
}
