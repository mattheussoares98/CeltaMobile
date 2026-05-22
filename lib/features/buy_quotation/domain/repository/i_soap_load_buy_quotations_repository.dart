import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';

abstract class ISoapLoadBuyQuotationsRepository {
  Future<List<BuyQuotationEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String? codeForFullSearch,
  });
}
