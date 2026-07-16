import 'package:celta_inventario/core/domain/entities/ec/ec_request_params.dart';
import 'package:celta_inventario/features/process_authorization/data/datasource/datasource.dart';
import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/receipt/domain/entity/entity.dart';

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
  Future<BSFSaleRequestErrorEntity> getSaleRequestErrors(
    EcRequestParams params, {
    required int enterpriseCode,
    required int saleRequestCode,
    required int customerCode,
    required SaleRequestErrorType errorType,
  }) async {
    final response = await datasource.getSaleRequestErrors(
      params,
      enterpriseCode: enterpriseCode,
      saleRequestCode: saleRequestCode,
      customerCode: customerCode,
      errorType: errorType,
    );

    return response.toEntity();
  }

  @override
  Future<void> vote(
    EcRequestParams params, {
    required int processCode,
    required bool authorized,
    String? observations,
  }) async {
    await datasource.vote(
      params,
      processCode: processCode,
      authorized: authorized,
      observations: observations,
    );
  }

  @override
  Future<BSFGoodsReceivingEntity> getGRDocFiscalNoteDifferences(
    EcRequestParams params,
    int documentCode,
  ) async {
    final response = await datasource.getGRDocFiscalNoteDifferences(
      params,
      documentCode,
    );

    return response.toEntity();
  }

  @override
  Future<void> markStatusJudgment(
    EcRequestParams params, {
    required List<int> grDocProductCodes,
    required int grDocGroupCode,
    required BsfGoodsReceivingProductJudgmentStatus judgmentStatus,
    required BsfGoodsReceivingProductJudgmentType judgementType,
  }) async {
    await datasource.markStatusJudgment(
      params,
      grDocProductCodes: grDocProductCodes,
      grDocGroupCode: grDocGroupCode,
      judgmentStatus: judgmentStatus,
      judgementType: judgementType,
    );
  }
}
