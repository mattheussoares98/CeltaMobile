import '../../models/models.dart';

abstract class ISoapLoadRequestTypeDatasource {
  Future<List<RequestTypeModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required bool inclusiveBuy,
    required bool inclusiveTransfer,
    required bool inclusiveSale,
  });
}
