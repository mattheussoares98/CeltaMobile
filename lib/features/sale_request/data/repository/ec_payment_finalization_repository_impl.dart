import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';

class EcPaymentFinalizationRepositoryImpl
    implements IEcPaymentFinalizationRepository {
  final IEcPaymentFinalizationDatasource datasource;
  EcPaymentFinalizationRepositoryImpl(this.datasource);

  @override
  Future<List<BSFPaymentFinalizationEntity>> getPaymentFinalizations({
    required int enterpriseCode,
    required EcRequestParams params,
  }) async {
    final response = await datasource.getPaymentFinalizations(
      enterpriseCode: enterpriseCode,
      params: params,
    );

    return response.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<BSFPaymentConditionEntity>> getPaymentConditions({
    required EcRequestParams params,
  }) async {
    final response = await datasource.getPaymentConditions(params: params);

    return response.map((e) => e.toEntity()).toList();
  }
}
