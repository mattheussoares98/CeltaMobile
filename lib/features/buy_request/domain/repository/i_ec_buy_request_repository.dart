import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';

abstract class IEcBuyRequestRepository {
  Future<List<EcBuyRequestDtoEntity>> loadShallow(
    LoadShallowBuyRequestParams params,
  );
}
