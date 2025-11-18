import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapInsertUpdateResearchDatasource
    implements ISoapInsertUpdateResearchDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdateResearchDatasource(this.soapRequest);

  @override
  Future<void> insertUpdate({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String name,
    int? researchCode,
    String? observations,
  }) async {
    await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "InsertUpdateResearchOfPriceResponse",
      soapAction: "InsertUpdateResearchOfPrice",
      serviceASMX: "CeltaResearchOfPriceService.asmx",
      typeOfResult: "InsertUpdateResearchOfPriceResult",
      parameters: {
        "json": json.encode({
          "CrossIdentity": crossIdentity,
          "Code": researchCode ?? 0, //0 add a new
          "EnterpriseCode": enterpriseCode,
          "Name": name,
          "Observation": observations,
        }),
      },
    );
  }
}
