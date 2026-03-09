import 'package:celta_inventario/core/domain/entities/product/product_entity.dart';

import '../../../data/datasource/products/products.dart';
import 'products.dart';

class EcommerceGetShallowProductsRepositoryImpl
    implements IEcommerceGetShallowProductsRepository {
  final IEcommerceGetShallowProductsDatasource datasource;

  EcommerceGetShallowProductsRepositoryImpl(this.datasource);

  @override
  Future<List<ProductEntity>> get({
    required String workingUrl,
    required String user,
    required String accessKey,
    required String name,
    required int enterpriseId,
  }) async {
    final products = await datasource.get(
      workingUrl: workingUrl,
      name: name,
      enterpriseId: enterpriseId,
      user: user,
      accessKey: accessKey,
    );

    return products.map((e) => e.toEntity()).toList();
  }
}
