import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';

import 'datasource.dart';

class EcSynchronizerDatasource implements IEcSynchronizerDatasource {
  final HttpClient httpClient;

  EcSynchronizerDatasource(this.httpClient);

  @override
  Future<dynamic> searchCount(EcRequestParams params) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/Synchronizer',
      method: 'get',
      headers: params.toHeaders(),
      body: params.toMap(),
    );

    //TODO create tests
    return response;
  }
}
