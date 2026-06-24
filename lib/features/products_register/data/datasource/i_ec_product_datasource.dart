import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/products_register/data/models/models.dart';

abstract class IEcProductDatasource {
  Future<BsfProductModel> get(
    EcRequestParams params, {
    required int productCode,
    required int enterpriseCode,
  });
}
