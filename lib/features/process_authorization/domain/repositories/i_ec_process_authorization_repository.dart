import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

abstract class IEcProcessAuthorizationRepository {
  Future<List<BSFProcessAuthorizationJudgmentEntity>> getJudgments(
    EcRequestParams params, {
    int? processCode,
  });
  Future<BsfProcessAuthorizationStatisticEntity> getStatistics(
    EcRequestParams params,
  );
}
