import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ISoapLoadBuyersRepository {
  Future<List<BuyerEntity>> load({
    required String workingUrl,
    required String crossIdentity,
  });
}
