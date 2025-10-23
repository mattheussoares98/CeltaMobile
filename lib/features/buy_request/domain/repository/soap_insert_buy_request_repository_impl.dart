import 'package:celta_intelligence/features/buy_request/domain/entities/buy_request_product_item_entity.dart';

import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import 'repository.dart';

class SoapInsertBuyRequestRepositoryImpl
    implements ISoapInsertBuyRequestRepository {
  final ISoapInsertBuyRequestDatasource datasource;
  SoapInsertBuyRequestRepositoryImpl(this.datasource);

  @override
  Future<String?> insertBuyRequest({
    required String baseUrl,
    required String crossIdentity,
    required int buyerCode,
    required int requestTypeCode,
    required int supplierCode,
    required String? observations,
    required List<int> enterpriseCodes,
    required List<BuyRequestProductItemEntity> products,
  }) async {
    return await datasource.insertBuyRequest(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      buyerCode: buyerCode,
      requestTypeCode: requestTypeCode,
      supplierCode: supplierCode,
      observations: observations,
      enterpriseCodes: enterpriseCodes,
      products: products
          .map((e) => BuyRequestProductItemModel.fromEntity(e))
          .toList(),
    );
  }
}
