import '../entities/entities.dart';

abstract class ISoapGetPriceSchedulesRepository {
  Future<List<PriceScheduleEntity>> getPriceSchedules({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  });
}
