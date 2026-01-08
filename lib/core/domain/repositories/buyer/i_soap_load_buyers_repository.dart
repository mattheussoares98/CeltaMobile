import '../../entities/entities.dart';

abstract class ISoapLoadBuyersRepository {
  Future<List<BuyerEntity>> load({
    required String workingUrl,
    required String crossIdentity,
  });
}
