import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapConfirmConferenceDatasource
    implements ISoapConfirmConferenceDatasource {
  final SoapRequest soapRequest;
  SoapConfirmConferenceDatasource(this.soapRequest);

  @override
  Future<void> confirm({
    required String baseUrl,
    required String crossIdentity,
    required int expeditionControlCode,
    required int stepCode,
  }) async {
    // await Future.delayed(Duration(seconds: 2));
    // throw Exception(); //TODO only for tests, remove after
    await soapRequest.post(
      url: baseUrl,
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
