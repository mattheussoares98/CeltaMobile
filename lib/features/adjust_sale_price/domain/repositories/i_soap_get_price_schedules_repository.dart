import 'package:celta_inventario/features/adjust_sale_price/domain/entities/entities.dart';

abstract class ISoapGetPriceSchedulesRepository {
  Future<List<PriceScheduleEntity>> getPriceSchedules({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  });
}
