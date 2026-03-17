import '../../data/datasource/datasource.dart';
import '../entities/entities.dart';
import 'repository.dart';

class EcGetSaleRequestsRepositoryImpl implements IEcGetSaleRequestsRepository {
  final IEcGetSaleRequestsDatasource datasource;
  EcGetSaleRequestsRepositoryImpl(this.datasource);

  @override
  Future<List<SaleRequestEntity>> get({
    required String workingUrl,
    required String user,
    required String accessKey,
    required List<int> enterpriseIds,
    required DateTime endDateHourOfCreation,
    required DateTime startDateHourOfCreation,
    List<String>? personalizedCodes,
    bool? mountCustomer,
    bool? mountSeller,
    bool? mountRequestType,
    bool? mountProducts,
  }) async {
    final response = await datasource.get(
      workingUrl: workingUrl,
      user: user,
      accessKey: accessKey,
      enterpriseIds: enterpriseIds,
      endDateHourOfCreation: endDateHourOfCreation,
      startDateHourOfCreation: startDateHourOfCreation,
      mountCustomer: mountCustomer,
      mountProducts: mountProducts,
      mountRequestType: mountRequestType,
      mountSeller: mountSeller,
      personalizedCodes: personalizedCodes,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
