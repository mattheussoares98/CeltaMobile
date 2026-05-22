import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';

abstract class ISoapProcessCartRepository {
  Future<ProcessedCartEntity> process({
    required String crossId,
    required String workingUrl,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int? covenantCode,
    required List<SaleRequestCartProductEntity> products,
  });
}
