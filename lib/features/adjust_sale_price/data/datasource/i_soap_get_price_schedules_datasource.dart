import 'package:celta_inventario/features/adjust_sale_price/data/models/models.dart';

abstract class ISoapGetPriceSchedulesDatasource {
  Future<List<PriceScheduleModel>> getPriceSchedules({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  });
}
