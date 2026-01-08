import '../entities/entities.dart';

abstract class ISoapInsertUpdateBuyQuotationRepository {
  Future<void> insertUpdate({
    required String urlInUse,
    required String crossIdentity,
    required BuyQuotationEntity buyQuotation,
    required DateTime now,
    required String? observations,
  });
}
