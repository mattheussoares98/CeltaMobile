import 'package:celta_inventario/features/buy_movement/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_movement/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_movement/domain/repositories/repositories.dart';

class EcBuyMovementRepositoryImpl implements IEcBuyMovementRepository {
  final IEcBuyMovementDatasource datasource;

  const EcBuyMovementRepositoryImpl(this.datasource);

  @override
  Future<List<EcBuyMovementDtoEntity>> loadShallow(
    LoadShallowBuyMovementParams params,
  ) async {
    final result = await datasource.loadShallow(params);
    return result.map((model) => model.toEntity()).toList();
  }

  @override
  Future<EcBuyMovementDtoEntity> loadDetails(
    LoadBuyMovementDetailsParams params,
  ) async {
    final result = await datasource.loadDetails(params);
    return result.toEntity();
  }
}
