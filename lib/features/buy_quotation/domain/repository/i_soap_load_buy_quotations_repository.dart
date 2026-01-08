import '../entities/entities.dart';

abstract class ISoapLoadBuyQuotationsRepository {
  Future<List<BuyQuotationEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String? codeForFullSearch,
  });
}
