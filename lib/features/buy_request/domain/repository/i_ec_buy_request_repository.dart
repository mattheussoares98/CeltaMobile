import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

abstract class IEcBuyRequestRepository {
  Future<List<EcBuyRequestDtoEntity>> loadShallow(
    EcRequestParams params, {
    required DateTime selectedDate,
    required int enterpriseCode,
  });
}
