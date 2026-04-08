import '../../../../core/domain/entities/entities.dart';
import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repository.dart';

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
}
