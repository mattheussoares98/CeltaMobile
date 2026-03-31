import 'package:celta_inventario/features/adjust_cost/domain/entity/adjust_cost_actualization_type.dart';

import '../../../../core/domain/contracts/contracts.dart';
import '../model/model.dart';
import 'datasource.dart';

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
    final forcedParameters = parameters.toEntity().copyWith(
      ActualizeDataAfterUpdate: true,
      UpdateChildCost: false,
      UpdateCostClass: false,
      UpdateEnterpriseGroup: true,
      ActualizationType: AdjustCostActualizationType.onlyOperationalCosts,
    );

    await httpClient.request(
      url: '$workingUrl/Products/AdjustCostsIndividual',
      method: 'post',
      headers: {'user': user, 'accessKey': accessKey},
      body: AdjustCostParametersModel.fromEntity(forcedParameters).toJson(),
    );
  }
}
