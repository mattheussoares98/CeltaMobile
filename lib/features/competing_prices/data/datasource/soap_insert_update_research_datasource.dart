import 'dart:convert';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/competing_prices/data/datasource/datasource.dart';

class SoapInsertUpdateResearchDatasource
    implements ISoapInsertUpdateResearchDatasource {
  final SoapRequest soapRequest;
  SoapInsertUpdateResearchDatasource(this.soapRequest);

  @override
  Future<void> insertUpdate({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String name,
    required int researchCode,
    required Map<String, dynamic> associateConcurrentParams,
    String? observations,
  }) async {
    await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "InsertUpdateResearchOfPriceResponse",
      soapAction: "InsertUpdateResearchOfPrice",
      serviceASMX: "CeltaResearchOfPriceService.asmx",
      typeOfResult: "InsertUpdateResearchOfPriceResult",
      parameters: {
        "json": json.encode({
          "CrossIdentity": crossIdentity,
          "Code": researchCode,
          "EnterpriseCode": enterpriseCode,
          "Name": name,
          "Observation": observations,
          ...associateConcurrentParams,
        }),
      },
    );
  }
}
