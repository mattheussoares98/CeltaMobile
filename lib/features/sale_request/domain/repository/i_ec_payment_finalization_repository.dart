import '../../../../core/domain/entities/entities.dart';
import '../entities/entities.dart';

abstract class IEcPaymentFinalizationRepository {
  Future<List<BSFPaymentFinalizationEntity>> getPaymentFinalizations({
    required int enterpriseCode,
    required EcRequestParams params,
  });

  Future<List<BSFPaymentConditionEntity>> getPaymentConditions({
    required EcRequestParams params,
  });
}
