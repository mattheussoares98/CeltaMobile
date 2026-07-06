import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';

abstract class IEcProcessAuthorizationDatasource {
  Future<List<BSFProcessAuthorizationJudgmentModel>> getJudgments(
    EcRequestParams params, {
    int? processCode,
  });
  Future<BsfProcessAuthorizationStatisticModel> getStatistics(
    EcRequestParams params,
  );
  Future<BSFSaleRequestErrorModel> getSaleRequestErrors(
    EcRequestParams params, {
    required int enterpriseCode,
    required int saleRequestCode,
    required int customerCode,
  });
}
