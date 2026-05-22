import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';

abstract class ISoapInsertUpdateBuyQuotationRepository {
  Future<void> insertUpdate({
    required String workingUrl,
    required String crossIdentity,
    required BuyQuotationEntity buyQuotation,
    required DateTime now,
    required String? observations,
  });
}
