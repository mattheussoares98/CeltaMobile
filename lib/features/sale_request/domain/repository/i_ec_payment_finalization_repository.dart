import '../../../../core/domain/entities/entities.dart';
import '../entities/entities.dart';

abstract class IEcPaymentFinalizationRepository {
  Future<List<BSFPaymentFinalizationEntity>> getPaymentOptions({
    required int enterpriseCode,
    required EcRequestParams params,
  });
}
