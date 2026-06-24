import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';

abstract class IEcProductRepository {
  Future<BsfProductEntity> get(
    EcRequestParams params, {
    required int productCode,
    required int enterpriseCode,
  });
}
