import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/buy_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';

// TODO: Create tests for EcBuyRequestRepositoryImpl.
class EcBuyRequestRepositoryImpl implements IEcBuyRequestRepository {
  final IEcBuyRequestDatasource datasource;

  const EcBuyRequestRepositoryImpl(this.datasource);

  @override
  Future<dynamic> loadShallow(
    EcRequestParams params, {
    required DateTime selectedDate,
  }) {
    return datasource.loadShallow(params, selectedDate: selectedDate);
  }
}
