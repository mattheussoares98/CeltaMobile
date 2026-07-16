import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

abstract class IEcProcessAuthorizationRepository {
  Future<List<BSFProcessAuthorizationJudgmentEntity>> getJudgments(
    EcRequestParams params, {
    int? processCode,
  });
  Future<BsfProcessAuthorizationStatisticEntity> getStatistics(
    EcRequestParams params,
  );

  Future<BSFSaleRequestErrorEntity> getSaleRequestErrors(
    EcRequestParams params, {
    required int enterpriseCode,
    required int saleRequestCode,
    required int customerCode,
    required SaleRequestErrorType errorType,
  });
  Future<void> vote(
    EcRequestParams params, {
    required int processCode,
    required bool authorized,
    String? observations,
  });

  Future<BSFGoodsReceivingEntity> getGRDocFiscalNoteDifferences(
    EcRequestParams params,
    int documentCode,
  );

  Future<void> markStatusJudgment(
    EcRequestParams params, {
    required List<int> grDocProductCodes,
    required int grDocGroupCode,
    required BsfGoodsReceivingProductJudgmentStatus judgmentStatus,
    required BsfGoodsReceivingProductJudgmentType judgementType,
  });
}
