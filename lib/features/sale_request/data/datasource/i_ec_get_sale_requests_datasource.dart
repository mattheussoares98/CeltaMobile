import '../models/models.dart';

abstract class IEcGetSaleRequestsDatasource {
  Future<List<EcSaleRequestModel>> get({
    required String workingUrl,
    required String name,
    required String user,
    required String accessKey,
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
