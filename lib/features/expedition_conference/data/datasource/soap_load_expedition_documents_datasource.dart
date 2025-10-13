import 'dart:convert';

import 'package:celta_intelligence/features/expedition_conference/data/models/expedition_document_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadExpeditionDocumentsDatasource
    implements ISoapLoadExpeditionDocumentsDatasource {
  final SoapRequest soapRequest;
  SoapLoadExpeditionDocumentsDatasource(this.soapRequest);

  @override
  Future<List<ExpeditionDocumentModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetExpeditionControlsToConferenceResponse",
      soapAction: "GetExpeditionControlsToConference",
      serviceASMX: "celtaproductservice.asmx",
      typeOfResult: "GetExpeditionControlsToConferenceResult",
      parameters: {
        "stringFilters": json.encode({
          "CrossIdentity": crossIdentity,
          "EnterpriseCode": enterpriseCode,
        }),
      },
    );

    return (json.decode(response) as List)
        .map((e) => ExpeditionDocumentModel.fromJson(e))
        .toList();
  }
}
