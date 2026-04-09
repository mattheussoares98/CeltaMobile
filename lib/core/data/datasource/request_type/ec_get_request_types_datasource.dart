import 'dart:convert';

import '../../../domain/contracts/contracts.dart';
import '../../../domain/entities/entities.dart';
import '../../models/models.dart';
import './request_type.dart';

class EcGetRequestTypesDatasource implements IEcGetRequestTypesDatasource {
  final HttpClient httpClient;

  EcGetRequestTypesDatasource(this.httpClient);

  @override
  Future<List<BSFRequestTypeModel>> search({
    required BSFSearchRequestTypeParametersEntity parameters,
    required int enterpriseCode,
    required EcRequestParams params,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/RequestTypes',
      method: 'post',
      headers: params.toHeaders(),
      body: {
        'parameters': BSFSearchRequestTypeParametersModel.fromEntity(
          parameters,
        ).toJson(),
        'enterpriseCode': enterpriseCode,
      },
    );

    return (json.decode(response) as List)
        .map((e) => BSFRequestTypeModel.fromJson(e))
        .toList();
  }
}
