import 'package:celta_inventario/features/buy_request/domain/entities/buy_request_product_item_entity.dart';

import '../datasource/datasource.dart';
import '../models/models.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';

class SoapInsertBuyRequestRepositoryImpl
    implements ISoapInsertBuyRequestRepository {
  final ISoapInsertBuyRequestDatasource datasource;
  SoapInsertBuyRequestRepositoryImpl(this.datasource);

  @override
  Future<String?> insertBuyRequest({
    required String workingUrl,
    required String crossIdentity,
    required int buyerCode,
    required int requestTypeCode,
    required int supplierCode,
    required String? observations,
    required List<int> enterpriseCodes,
    required List<BuyRequestProductItemEntity> products,
  }) async {
    return await datasource.insertBuyRequest(
      workingUrl: workingUrl,
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
