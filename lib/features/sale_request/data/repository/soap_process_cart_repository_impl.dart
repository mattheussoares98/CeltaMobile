import 'package:celta_inventario/features/sale_request/domain/entities/processed_cart_entity.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/sale_request_cart_product_entity.dart';

import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

class SoapProcessCartRepositoryImpl implements ISoapProcessCartRepository {
  final ISoapProcessCartDatasource datasource;
  SoapProcessCartRepositoryImpl(this.datasource);

  @override
  Future<ProcessedCartEntity> process({
    required String crossId,
    required String workingUrl,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int? covenantCode,
    required List<SaleRequestCartProductEntity> products,
  }) async {
    final response = await datasource.process(
      crossId: crossId,
      workingUrl: workingUrl,
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
      customerCode: customerCode,
      covenantCode: covenantCode,
      products: products
          .map((e) => SoapSaleRequestProductModel.fromEntity(e))
          .toList(),
    );

    return response.toEntity();
  }
}
