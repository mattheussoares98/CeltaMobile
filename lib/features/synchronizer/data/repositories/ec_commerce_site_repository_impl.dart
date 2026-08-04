import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';

class EcCommerceSiteRepositoryImpl implements IEcCommerceSiteRepository {
  final IEcCommerceSiteDatasource datasource;

  const EcCommerceSiteRepositoryImpl(this.datasource);

  @override
  Future<List<EcCommerceSiteEntity>> getCommerceSites(
    EcRequestParams params,
    int enterpriseCode,
  ) async => (await datasource.getCommerceSites(
    params,
    enterpriseCode,
  )).map((model) => model.toEntity()).toList();
}
