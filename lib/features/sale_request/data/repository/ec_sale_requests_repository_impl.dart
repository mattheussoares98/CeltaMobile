import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

class EcSaleRequestsRepositoryImpl implements IEcSaleRequestsRepository {
  final IEcSaleRequestsDatasource datasource;
  EcSaleRequestsRepositoryImpl(this.datasource);

  @override
  Future<EcPaginationResults<SaleRequestEntity>> get({
    required EcRequestParams params,
    DateTime? startDateHourOfCreation,
    DateTime? endDateHourOfCreation,
    List<int>? enterpriseIds,
    int? id,
    List<String>? personalizedCodes,
    bool? mountCustomer,
    bool? mountSeller,
    bool? mountRequestType,
    bool? mountProducts,
  }) async {
    final response = await datasource.get(
      params: params,
      enterpriseIds: enterpriseIds,
      endDateHourOfCreation: endDateHourOfCreation ?? DateTime.now(),
      startDateHourOfCreation: startDateHourOfCreation,
      mountCustomer: mountCustomer,
      mountProducts: mountProducts,
      mountRequestType: mountRequestType,
      mountSeller: mountSeller,
      personalizedCodes: personalizedCodes,
      id: id,
    );

    return response.map((e) => e.toEntity());
  }

  @override
  Future<BSFSaleRequestEntity> getComplete({
    required int saleRequestCode,
    required int enterpriseCode,
    required int customerCode,
    required EcRequestParams params,
  }) async {
    final response = await datasource.getComplete(
      saleRequestCode: saleRequestCode,
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      params: params,
    );

    return response.toEntity();
  }

  @override
  Future<void> update({
    required BSFSaleRequestEntity saleRequest,
    required int enterpriseCode,
    required EcRequestParams params,
  }) async {
    await datasource.update(
      saleRequest: BSFSaleRequestModel.fromEntity(saleRequest),
      enterpriseCode: enterpriseCode,
      params: params,
    );
  }
}
