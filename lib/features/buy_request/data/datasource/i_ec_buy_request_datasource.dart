import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/data/models/models.dart';

abstract class IEcBuyRequestDatasource {
  Future<List<EcBuyRequestDtoModel>> loadShallow(
    EcRequestParams params, {
    required DateTime selectedDate,
    required int enterpriseCode,
  });
}
