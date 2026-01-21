import 'package:celta_inventario/features/adjust_sale_price/domain/entities/price_schedule_entity.dart';
import 'package:celta_inventario/features/adjust_sale_price/domain/repositories/repositories.dart';

import '../../data/datasource/datasource.dart';

class SoapGetPriceSchedulesRepositoryImpl
    implements ISoapGetPriceSchedulesRepository {
  final ISoapGetPriceSchedulesDatasource soapGetPriceSchedulesDatasource;

  SoapGetPriceSchedulesRepositoryImpl({
    required this.soapGetPriceSchedulesDatasource,
  });

  @override
  Future<List<PriceScheduleEntity>> getPriceSchedules({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  }) async {
    final response = await soapGetPriceSchedulesDatasource.getPriceSchedules(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      productCode: productCode,
      productPackingCode: productPackingCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
