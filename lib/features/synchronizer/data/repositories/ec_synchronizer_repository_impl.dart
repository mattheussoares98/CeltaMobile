import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';

class EcSynchronizerRepositoryImpl implements IEcSynchronizerRepository {
  final IEcSynchronizerDatasource datasource;

  const EcSynchronizerRepositoryImpl(this.datasource);

  @override
  Future<List<SynchronizerErrorSummaryEntity>> searchCount(
    EcRequestParams params,
  ) async => (await datasource.searchCount(
    params,
  )).map((model) => model.toEntity()).toList();

  @override
  Future<SynchronizerErrorDetailsEntity> searchByKey(
    EcRequestParams params,
    String errorKey,
  ) async => (await datasource.searchByKey(params, errorKey)).toEntity();

  @override
  Future<void> markCouponsToReadAgain(
    EcRequestParams params,
    List<int> codes,
  ) async => await datasource.markCouponsToReadAgain(params, codes);

  @override
  Future<void> deleteScheduleErrors(
    EcRequestParams params,
    List<int> codes,
  ) async => await datasource.deleteScheduleErrors(params, codes);
}
