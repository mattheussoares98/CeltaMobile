import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';

abstract class IEcSaleRequestsDatasource {
  Future<EcPaginationResults<EcSaleRequestModel>> get({
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

  Future<BSFSaleRequestModel> getComplete({
    required int saleRequestCode,
    required int enterpriseCode,
    required int customerCode,
    required EcRequestParams params,
  });

  Future<bool> update({
    required BSFSaleRequestModel saleRequest,
    required int enterpriseCode,
    required EcRequestParams params,
  });
  Future<List<BSFPaymentFinalizationModel>> getPaymentOptions({
    required int enterpriseCode,
    required EcRequestParams params,
  });
}
