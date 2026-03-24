import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';

abstract class IEcGetSaleRequestsDatasource {
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

  Future<dynamic> getComplete({
    required int saleRequestCode,
    required int enterpriseCode,
    required int customerCode,
    required EcRequestParams params,
  });
}
