import '../../../../core/domain/entities/entities.dart';
import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repository.dart';

class EcGetSaleRequestsRepositoryImpl implements IEcGetSaleRequestsRepository {
  final IEcGetSaleRequestsDatasource datasource;
  EcGetSaleRequestsRepositoryImpl(this.datasource);

  @override
  Future<EcPaginationResults<SaleRequestEntity>> get({
    required EcRequestParams params,
    required List<int> enterpriseIds,
    required DateTime startDateHourOfCreation,
    required DateTime? endDateHourOfCreation,
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
    );

    return response.map((e) => e.toEntity());
  }
}
