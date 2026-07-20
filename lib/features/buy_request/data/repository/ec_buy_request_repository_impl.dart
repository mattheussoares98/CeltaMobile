import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';

class EcBuyRequestRepositoryImpl implements IEcBuyRequestRepository {
  final IEcBuyRequestDatasource datasource;

  const EcBuyRequestRepositoryImpl(this.datasource);

  @override
  Future<List<EcBuyRequestDtoEntity>> loadShallow(
    LoadShallowBuyRequestParams params,
  ) async {
    final result = await datasource.loadShallow(params);
    return result.map((e) => e.toEntity()).toList();
  }
}
