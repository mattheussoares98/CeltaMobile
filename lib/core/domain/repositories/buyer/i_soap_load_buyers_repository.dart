import '../../entities/entities.dart';

abstract class ISoapLoadBuyersRepository {
  Future<List<BuyerEntity>> load({
    required String urlInUse,
    required String crossIdentity,
  });
}
