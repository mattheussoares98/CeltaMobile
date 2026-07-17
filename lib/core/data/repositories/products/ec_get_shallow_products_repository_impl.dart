import 'package:celta_inventario/core/data/datasource/products/products.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/product/product_entity.dart';
import 'package:celta_inventario/core/domain/repositories/products/products.dart';

class EcGetShallowProductsRepositoryImpl
    implements IEcGetShallowProductsRepository {
  final IEcGetShallowProductsDatasource datasource;

  EcGetShallowProductsRepositoryImpl(this.datasource);

  @override
  Future<List<ProductEntity>> get({
    required String workingUrl,
    required String user,
    required String accessKey,
    required String name,
    required int enterpriseId,
    required CancelToken cancelToken,
    int? recordsByPage,
  }) async {
    final products = await datasource.get(
      workingUrl: workingUrl,
      name: name,
      enterpriseId: enterpriseId,
      user: user,
      accessKey: accessKey,
      cancelToken: cancelToken,
      recordsByPage: recordsByPage ?? 10,
    );

    return products.map((e) => e.toEntity()).toList();
  }
}
