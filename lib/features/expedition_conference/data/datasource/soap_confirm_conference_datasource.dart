import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapConfirmConferenceDatasource
    implements ISoapConfirmConferenceDatasource {
  final SoapRequest soapRequest;
  SoapConfirmConferenceDatasource(this.soapRequest);

  @override
  Future<void> confirm({
    required String urlInUse,
    required String crossIdentity,
    required int expeditionControlCode,
    required int stepCode,
  }) async {
    await soapRequest.post(
      url: urlInUse,
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
