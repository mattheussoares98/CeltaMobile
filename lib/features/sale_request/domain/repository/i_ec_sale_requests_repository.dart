import '../../../../core/domain/entities/entities.dart';
import '../entities/entities.dart';

abstract class IEcSaleRequestsRepository {
  Future<EcPaginationResults<SaleRequestEntity>> get({
    required EcRequestParams params,
    DateTime? startDateHourOfCreation,
    DateTime? endDateHourOfCreation,
    List<int>? enterpriseIds,
    int? id,
    List<String>? personalizedCodes,
    bool? mountCustomer,
    bool? mountSeller,
    bool? mountRequestType,
    bool? mountProducts,
  });

  Future<BSFSaleRequestEntity> getComplete({
    required int saleRequestCode,
    required int enterpriseCode,
    required int customerCode,
    required EcRequestParams params,
  });

  Future<bool> update({
    required BSFSaleRequestEntity saleRequest,
    required int enterpriseCode,
    required EcRequestParams params,
  });
  Future<List<BSFPaymentFinalizationEntity>> getPaymentOptions({
    required int enterpriseCode,
    required EcRequestParams params,
  });
}
