import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/adjust_cost/data/model/model.dart';
import 'package:celta_inventario/features/adjust_cost/data/datasource/datasource.dart';

class EcAdjustCostDatasource implements IEcAdjustCostDatasource {
  final HttpClient httpClient;
  EcAdjustCostDatasource(this.httpClient);

  @override
  Future<void> adjust({
    required String workingUrl,
    required String user,
    required String accessKey,
    required AdjustCostParametersModel parameters,
  }) async {
    await httpClient.request(
      url: '$workingUrl/Api/Products/AdjustCostsIndividual',
      method: 'post',
      headers: {'user': user, 'accessKey': accessKey},
      body: parameters.toJson(),
    );
  }
}
