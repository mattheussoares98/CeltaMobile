import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';

// TODO: Create tests for EcBuyRequestRepositoryImpl.
class EcBuyRequestRepositoryImpl implements IEcBuyRequestRepository {
  final IEcBuyRequestDatasource datasource;

  const EcBuyRequestRepositoryImpl(this.datasource);

  @override
  Future<List<EcBuyRequestDtoEntity>> loadShallow(
    EcRequestParams params, {
    required DateTime selectedDate,
    required int enterpriseCode,
  }) async {
    final result = await datasource.loadShallow(
      params,
      selectedDate: selectedDate,
      enterpriseCode: enterpriseCode,
    );
    return result.map((e) => e.toEntity()).toList();
  }
}
