// file:///c:/Celta/CeltaMobile/lib/features/products_register/domain/repository/ec_product_repository_impl.dart
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/products_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/products_register/domain/repositories/repositories.dart';

class EcProductRepositoryImpl implements IEcProductRepository {
  final IEcProductDatasource _datasource;

  EcProductRepositoryImpl(this._datasource);

  @override
  Future<dynamic> get(
    EcRequestParams params, {
    required int productCode,
    required int enterpriseCode,
  }) {
    return _datasource.get(
      params,
      productCode: productCode,
      enterpriseCode: enterpriseCode,
    );
  }
}
