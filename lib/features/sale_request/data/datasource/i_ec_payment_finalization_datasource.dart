import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';

abstract class IEcPaymentFinalizationDatasource {
  Future<List<BSFPaymentFinalizationModel>> getPaymentFinalizations({
    required int enterpriseCode,
    required EcRequestParams params,
  });

  Future<List<BSFPaymentConditionModel>> getPaymentConditions({
    required EcRequestParams params,
  });
}
