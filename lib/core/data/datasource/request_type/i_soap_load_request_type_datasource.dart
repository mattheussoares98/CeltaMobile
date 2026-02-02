import '../../models/models.dart';

abstract class ISoapLoadRequestTypeDatasource {
  Future<List<RequestTypeModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required bool inclusiveBuy,
    required bool inclusiveTransfer,
    required bool inclusiveSale,
    required int enterpriseCode,
  });
}
