import 'dart:convert';

import 'package:celta_intelligence/features/competing_prices/data/models/research_model.dart';

import '../../../../core/domain/contracts/contracts.dart';
import 'datasource.dart';

class SoapLoadResearchsDatasource implements ISoapLoadResearchsDatasource {
  final SoapRequest soapRequest;
  SoapLoadResearchsDatasource(this.soapRequest);

  @override
  Future<List<ResearchModel>> load({
    required String crossIdentity,
    required String baseUrl,
    required int enterpriseCode,
    String? searchValue,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      typeOfResponse: "GetResearchOfPriceJsonResponse",
      soapAction: "GetResearchOfPriceJson",
      serviceASMX: "CeltaResearchOfPriceService.asmx",
      typeOfResult: "GetResearchOfPriceJsonResult",
      parameters: {
        "json": json.encode({
          "CrossIdentity": crossIdentity,
          "EnterpriseCode": enterpriseCode,
          // "InitialCreationDate": "0001-01-01T00:00:00",
          // "FinalCreationDate": DateTime.now().toIso8601String(),
          "SearchValue": searchValue ?? "",
          "SearchTypeInt": searchValue is int ? 1 : 2,
        }),
      },
    );

    return (response as List)
        .map((e) => ResearchModel.fromJson(json.decode(e)))
        .toList();
  }
}
