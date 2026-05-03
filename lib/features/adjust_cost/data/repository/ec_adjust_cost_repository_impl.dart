import '../datasource/datasource.dart';
import '../model/model.dart';
import 'package:celta_inventario/features/adjust_cost/domain/entity/entity.dart';
import 'package:celta_inventario/features/adjust_cost/domain/repository/repository.dart';

class EcAdjustCostRepositoryImpl implements IEcAdjustCostRepository {
  final IEcAdjustCostDatasource datasource;
  EcAdjustCostRepositoryImpl(this.datasource);

  @override
  Future<void> adjust({
    required String workingUrl,
    required String user,
    required String accessKey,
    required AdjustCostParametersEntity parameters,
  }) async {
    await datasource.adjust(
      workingUrl: workingUrl,
      user: user,
      accessKey: accessKey,
      parameters: AdjustCostParametersModel.fromEntity(
        parameters.copyWith(
          ActualizeDataAfterUpdate: true,
          UpdateChildCost: false,
          UpdateCostClass: false,
          UpdateEnterpriseGroup: true,
          ActualizationType: AdjustCostActualizationType.onlyOperationalCosts,
        ),
      ),
    );
  }
}
