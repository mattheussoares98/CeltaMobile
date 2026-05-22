import 'package:celta_inventario/features/buy_quotation/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_quotation/data/models/models.dart';

abstract class ISoapLoadBuyQuotationsDatasource {
  Future<List<BuyQuotationModel>> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required bool isCompleteSearch,
    required String searchValue,
    required SearchBuyQuotationDataType dataType,
    required bool inclusiveExpired,
  });
}
