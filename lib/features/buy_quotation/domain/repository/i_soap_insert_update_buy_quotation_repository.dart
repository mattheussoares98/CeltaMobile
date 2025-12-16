import '../entities/entities.dart';

abstract class ISoapInsertUpdateBuyQuotationRepository {
  Future<void> insertUpdate({
    required String baseUrl,
    required String crossIdentity,
    required BuyQuotationEntity buyQuotation,
  });
}
