import '../entities/entities.dart';

abstract class ISoapLoadBuyQuotationsRepository {
  Future<List<BuyQuotationEntity>> load({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
    required String? codeForFullSearch,
  });
}
