import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/models/models.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';

abstract class IEcSynchronizerDatasource {
  Future<List<SynchronizerErrorSummaryModel>> searchCount(
    EcRequestParams params,
  );

  Future<SynchronizerErrorDetailsModel> searchByKey(
    EcRequestParams params,
    String errorKey,
  );

  Future<void> markCouponsToReadAgain(EcRequestParams params, List<int> codes);

  Future<void> linkSaleRequestProductNotFound(
    EcRequestParams params, {
    required int productNotFoundCode,
    required int productCode,
    required int productPackingCode,
  });

  Future<void> markSaleRequestsWithErrorToReadAgain(
    EcRequestParams params,
    List<int> codes,
  );

  Future<void> markSaleMovementScanntechLoadErrorsToReadAgain(
    EcRequestParams params,
    List<int> codes,
  );

  Future<void> unmarkSaleRequestsMarked(
    EcRequestParams params,
    List<int> codes,
  );

  Future<void> insertSaleRequestsToReadAgain(
    EcRequestParams params, {
    required int enterpriseCode,
    required int enterpriseCommerceSiteCode,
    required List<String> saleRequestIds,
  });

  Future<void> deleteSaleRequestsWithError(
    EcRequestParams params,
    List<int> codes,
  );

  Future<void> markProductsToSendAgain(
    EcRequestParams params,
    List<ProductWithErrorActionParams> products,
  );

  Future<void> unmarkProductsToSendAgain(
    EcRequestParams params,
    List<ProductWithErrorActionParams> products,
  );

  Future<void> markProductsToIgnoreError(
    EcRequestParams params,
    List<ProductWithErrorActionParams> products,
  );

  Future<void> deleteScheduleErrors(EcRequestParams params, List<int> codes);

  Future<void> markSendDataToSendAgain(
    EcRequestParams params, {
    required BSFSendDataType sendDataType,
    required List<int> codes,
    required bool mark,
  });
}
