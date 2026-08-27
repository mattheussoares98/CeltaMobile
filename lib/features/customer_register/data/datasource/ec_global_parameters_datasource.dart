import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/customer_register/data/models/models.dart';

class EcGlobalParametersDatasource implements IEcGlobalParametersDatasource {
  final HttpClient httpClient;

  const EcGlobalParametersDatasource(this.httpClient);

  @override
  Future<BSFGlobalParametersModel> getGlobalParameters(
    EcRequestParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/GlobalParameters',
      method: 'get',
      headers: params.toHeaders(),
    );

    return BSFGlobalParametersModel.fromJson(response as Map);
  }
}
