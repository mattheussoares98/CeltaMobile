import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

class SoapSaveSaleRequestRepositoryImpl
    implements ISoapSaveSaleRequestRepository {
  final ISoapSaveSaleRequestDatasource datasource;
  SoapSaveSaleRequestRepositoryImpl(this.datasource);

  @override
  Future<String?> save({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int requestTypeCode,
    required SaleRequestEntity saleRequest,
  }) async {
    return await datasource.save(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
      saleRequest: SoapSaleRequestModel.fromEntity(
        saleRequest.copyWith(
          cart: saleRequest.cart.map(
            (key, value) => MapEntry(
              key,
              value.copyWith(
                DiscountValue: value.DiscountValue == null
                    ? null
                    : (value.DiscountValue ?? 0) / value.Quantity,
                DiscountPercentageOrValue: PercentageOrValue.reais,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
