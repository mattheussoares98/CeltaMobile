import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';

abstract class IEcProcessAuthorizationDatasource {
  Future<List<BSFProcessAuthorizationJudgmentModel>> getJudgments(
    EcRequestParams params,
  );
  Future<BsfProcessAuthorizationStatisticModel> getStatistics(
    EcRequestParams params,
  );
}
