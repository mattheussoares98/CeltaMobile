import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/data/models/models.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';

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
    required SaleRequestErrorType errorType,
  });
  Future<void> vote(
    EcRequestParams params, {
    required int processCode,
    required bool authorized,
    String? observations,
  });

  Future<dynamic> getGRDocFiscalNoteDifferences(
    EcRequestParams params,
    int documentCode,
  );
}
