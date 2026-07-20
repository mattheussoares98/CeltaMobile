import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcBuyRequestRepository {
  Future<dynamic> loadShallow(
    EcRequestParams params, {
    required DateTime selectedDate,
  });
}
