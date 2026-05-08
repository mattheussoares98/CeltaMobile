import '../../../../core/domain/entities/entities.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repository/repository.dart';
import '../datasource/datasource.dart';

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
