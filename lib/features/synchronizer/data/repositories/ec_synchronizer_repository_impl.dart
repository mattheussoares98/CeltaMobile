import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/synchronizer/data/datasource/datasource.dart';
import 'package:celta_inventario/features/synchronizer/domain/repositories/repositories.dart';

class EcSynchronizerRepositoryImpl implements IEcSynchronizerRepository {
  final IEcSynchronizerDatasource datasource;

  EcSynchronizerRepositoryImpl(this.datasource);

  @override
  Future<dynamic> searchCount(EcRequestParams params) async {
    final response = await datasource.searchCount(params);

    //TODO create tests
    return response;
  }
}
