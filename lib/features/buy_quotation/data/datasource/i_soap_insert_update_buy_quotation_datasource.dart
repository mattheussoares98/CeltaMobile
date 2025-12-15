import '../../../../core/data/models/models.dart';
import '../models/models.dart';

abstract class ISoapInsertUpdateBuyQuotationDatasource {
  Future<void> insertUpdate({
    required String baseUrl,
    required String crossIdentity,
    required int? code,
    required DateTime? dateOfCreation,
    required DateTime? dateOfLimit,
    required int? personalizedCode,
    required String? observations,
    required BuyerModel? buyer,
    required List<BuyQuotationEnterpriseModel>? Enterprises,
    required List<BuyQuotationProductsModel>? Products,
  });
}
