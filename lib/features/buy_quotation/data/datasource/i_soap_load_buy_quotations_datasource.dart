import '../../domain/entities/entities.dart';
import '../models/models.dart';

abstract class ISoapLoadBuyQuotationsDatasource {
  Future<List<BuyQuotationModel>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required bool isCompleteSearch,
    required String searchValue,
    required SearchBuyQuotationDataType dataType,
  });
}
