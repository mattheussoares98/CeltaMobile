import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/products_register/data/datasource/datasource.dart';
import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/products_register/domain/repositories/repositories.dart';

class EcProductRepositoryImpl implements IEcProductRepository {
  final IEcProductDatasource _datasource;

  EcProductRepositoryImpl(this._datasource);

  @override
  Future<BsfProductEntity> get(
    EcRequestParams params, {
    required int productCode,
    required int enterpriseCode,
  }) async {
    final value = await _datasource.get(
      params,
      productCode: productCode,
      enterpriseCode: enterpriseCode,
    );

    return value.toEntity();
  }
}
