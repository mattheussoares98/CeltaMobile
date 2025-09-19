import '../models/models.dart';

abstract class ISoapGetPriceSchedulesDatasource {
  Future<List<PriceScheduleModel>> getPriceSchedules({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  });
}
