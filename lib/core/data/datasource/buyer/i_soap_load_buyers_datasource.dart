import '../../models/models.dart';

abstract class ISoapLoadBuyersDatasource {
  Future<List<BuyerModel>> load({
    required String workingUrl,
    required String crossIdentity,
  });
}
