import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

abstract class IEcProcessAuthorizationRepository {
  Future<List<BSFAuthorizationProcessJudgmentEntity>> getJudgments(
    EcRequestParams params,
  );
  Future<BsfProcessAuthorizationStatisticEntity> getStatistics(
    EcRequestParams params,
  );
}
