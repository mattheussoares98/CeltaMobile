import '../../entities/entities.dart';

abstract class ISoapLoadRequestTypeRepository {
  Future<List<RequestTypeEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required bool inclusiveBuy,
    required bool inclusiveTransfer,
    required bool inclusiveSale,
  });
}
