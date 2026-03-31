import '../../data/datasource/datasource.dart';
import '../../data/model/model.dart';
import '../entity/entity.dart';
import 'repository.dart';

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
      parameters: AdjustCostParametersModel.fromEntity(parameters),
    );
  }
}
