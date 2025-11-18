import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';
import 'datasource.dart';

class SoapLoadConcurrentsDatasource implements ISoapLoadConcurrentsDatasource {
  final SoapRequest soapRequest;
  SoapLoadConcurrentsDatasource(this.soapRequest);

  @override
  Future<List<ConcurrentModel>> load({
    required String crossIdentity,
    required String baseUrl,
    required SearchConcurrentType searchType,
    required String searchValue,
  }) async {
    final response = await soapRequest.post(
      url: baseUrl,
      soapAction: "GetConcurrentJson",
      typeOfResponse: "GetConcurrentJsonResponse",
      serviceASMX: "CeltaResearchOfPriceService.asmx",
      typeOfResult: "GetConcurrentJsonResult",
      parameters: {
        "json": json.encode({
          "CrossIdentity": crossIdentity,
          "SearchValue": searchValue,
          "SearchTypeInt": searchType.code,
        }),
      },
    );

    return (json.decode(response) as List)
        .map((e) => ConcurrentModel.fromJson(e))
        .toList();
  }
}
