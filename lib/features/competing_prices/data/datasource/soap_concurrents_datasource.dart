import 'dart:convert';

import '../../../../core/domain/contracts/contracts.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';
import 'datasource.dart';

class SoapConcurrentsDatasource implements ISoapConcurrentsDatasource {
  final SoapRequest soapRequest;
  SoapConcurrentsDatasource(this.soapRequest);

  @override
  Future<List<ConcurrentModel>> load({
    required String crossIdentity,
    required String workingUrl,
    required SearchConcurrentType searchType,
    required String searchValue,
  }) async {
    final response = await soapRequest.post(
      url: workingUrl,
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

  @override
  Future<void> insertUpdate({
    required String crossIdentity,
    required String workingUrl,
    required ConcurrentModel concurrent,
  }) async {
    await soapRequest.post(
      url: workingUrl,
      typeOfResponse: "InsertUpdateConcurrentJsonResponse",
      soapAction: "InsertUpdateConcurrentJson",
      serviceASMX: "CeltaResearchOfPriceService.asmx",
      typeOfResult: "InsertUpdateConcurrentJsonResult",
      parameters: {
        "json": json.encode({
          "ConcurrentCode": concurrent.ConcurrentCode,
          "CrossIdentity": crossIdentity,
          "Name": concurrent.Name,
          "Observation": concurrent.Observation,
          "Address": concurrent.Address?.toJson(),
        }),
      },
    );
  }
}
