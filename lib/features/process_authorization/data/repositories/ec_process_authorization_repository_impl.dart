import 'package:celta_inventario/core/domain/entities/ec/ec_request_params.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';

class EcProcessAuthorizationRepositoryImpl
    implements IEcProcessAuthorizationRepository {
  final IEcProcessAuthorizationDatasource datasource;

  EcProcessAuthorizationRepositoryImpl(this.datasource);

  @override
  Future<List<BSFProcessAuthorizationJudgmentEntity>> getJudgments(
    EcRequestParams params, {
    int? processCode,
  }) async {
    final response = await datasource.getJudgments(
      params,
      processCode: processCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }

  @override
  Future<BsfProcessAuthorizationStatisticEntity> getStatistics(
    EcRequestParams params,
  ) async {
    final response = await datasource.getStatistics(params);

    return response.toEntity();
  }

  @override
  Future<dynamic> getSaleRequestErrors(
    //TODO create entity
    EcRequestParams params, {
    required int enterpriseCode,
    required int saleRequestCode,
    required int customerCode,
  }) async {
    final response = await datasource.getSaleRequestErrors(
      params,
      enterpriseCode: enterpriseCode,
      saleRequestCode: saleRequestCode,
      customerCode: customerCode,
    );

    //TODO create tests
    return response;
  }
}
