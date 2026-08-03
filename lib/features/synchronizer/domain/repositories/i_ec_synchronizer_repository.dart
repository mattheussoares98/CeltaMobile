import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

abstract class IEcSynchronizerRepository {
  Future<List<SynchronizerErrorSummaryEntity>> searchCount(
    EcRequestParams params,
  );

  Future<SynchronizerErrorDetailsEntity> searchByKey(
    EcRequestParams params,
    String errorKey,
  );

  Future<void> markCouponsToReadAgain(EcRequestParams params, List<int> codes);

  Future<void> deleteScheduleErrors(EcRequestParams params, List<int> codes);
}
