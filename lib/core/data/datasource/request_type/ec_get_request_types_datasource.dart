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
    required EcRequestTypeParametersEntity parameters,
    required EcRequestParams params,
  }) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/RequestTypes/v2',
      method: 'post',
      headers: params.toHeaders(),
      body: EcRequestTypeParametersModel.fromEntity(parameters).toJson(),
    );

    return (json.decode(response) as List)
        .map((e) => BSFRequestTypeModel.fromJson(e))
        .toList();
  }
}
