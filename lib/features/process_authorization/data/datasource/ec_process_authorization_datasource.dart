import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/ec/ec_request_params.dart';

import 'datasource.dart';

class EcProcessAuthorizationDatasource
    implements IEcProcessAuthorizationDatasource {
  final HttpClient httpClient;

  EcProcessAuthorizationDatasource(this.httpClient);

  @override
  Future<dynamic> getJudgments(EcRequestParams params) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/ProcessAuthorization/Judgment',
      method: 'post',
      headers: params.toHeaders(),
      body: params.toMap(),
    );

    //TODO convert to model and create tests
    return response;
  }

  @override
  Future<dynamic> getStatistics(EcRequestParams params) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/ProcessAuthorization/Statistics',
      method: 'post',
      headers: params.toHeaders(),
      body: params.toMap(),
    );

    //TODO convert to model and create tests
    return response;
  }
}
