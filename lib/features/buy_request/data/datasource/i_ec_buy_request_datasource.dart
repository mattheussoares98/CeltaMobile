import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcBuyRequestDatasource {
  Future<dynamic> loadShallow(
    EcRequestParams params, {
    required DateTime selectedDate,
  });
}
