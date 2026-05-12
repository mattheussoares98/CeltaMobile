import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/customer/customer.dart';
import '../../datasource/customer/customer.dart';

class EcBSFCustomersRepositoryImpl implements IEcBSFCustomersRepository {
  final IEcBSFCustomersDatasource datasource;

  EcBSFCustomersRepositoryImpl(this.datasource);

  @override
  Future<List<BSFCustomerEntity>> searchForMobileApp({
    required EcRequestParams params,
    required String searchValue,
    required int enterpriseCode,
    required bool searchByPersonalizedCode,
  }) async {
    final result = await datasource.searchForMobileApp(
      params: params,
      searchValue: searchValue,
      enterpriseCode: enterpriseCode,
      searchByPersonalizedCode: searchByPersonalizedCode,
    );

    return result.map((e) => e.toEntity()).toList();
  }
}
