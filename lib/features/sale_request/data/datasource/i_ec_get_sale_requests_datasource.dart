import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';

abstract class IEcGetSaleRequestsDatasource {
  Future<EcPaginationResults<EcSaleRequestModel>> get({
    required EcRequestParams params,
    required List<int> enterpriseIds,
    required DateTime endDateHourOfCreation,
    required DateTime startDateHourOfCreation,
    List<String>? personalizedCodes,
    bool? mountCustomer,
    bool? mountSeller,
    bool? mountRequestType,
    bool? mountProducts,
  });
}
