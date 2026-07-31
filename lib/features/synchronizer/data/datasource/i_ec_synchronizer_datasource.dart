import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';

abstract class IEcSynchronizerDatasource {
  Future<List<SynchronizerErrorSummaryModel>> searchCount(
    EcRequestParams params,
  );

  Future<SynchronizerErrorDetailsModel> searchByKey(
    EcRequestParams params,
    String errorKey,
  );

  Future<void> markCouponsToReadAgain(EcRequestParams params, List<int> codes);
}
