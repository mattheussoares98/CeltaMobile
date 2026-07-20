import 'package:celta_inventario/features/buy_request/data/models/models.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

abstract class IEcBuyRequestDatasource {
  Future<List<EcBuyRequestDtoModel>> loadShallow(
    LoadShallowBuyRequestParams params,
  );
}
