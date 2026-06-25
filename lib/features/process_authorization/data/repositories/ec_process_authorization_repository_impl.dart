import 'package:celta_inventario/core/domain/entities/ec/ec_request_params.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';

class EcProcessAuthorizationRepositoryImpl
    implements IEcProcessAuthorizationRepository {
  final IEcProcessAuthorizationDatasource datasource;

  EcProcessAuthorizationRepositoryImpl(this.datasource);

  @override
  Future<dynamic> getJudgments(EcRequestParams params) async {
    final response = await datasource.getJudgments(params);

    //TODO convert to entity and create tests
    return response;
  }

  @override
  Future<BsfProcessAuthorizationStatisticEntity> getStatistics(
    EcRequestParams params,
  ) async {
    final response = await datasource.getStatistics(params);

    return response.toEntity();
  }
}
