import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/customer/customer.dart';
import 'package:celta_inventario/core/data/datasource/customer/customer.dart';

class EcCustomersRepositoryImpl implements IEcCustomersRepository {
  final IEcCustomersDatasource datasource;

  EcCustomersRepositoryImpl(this.datasource);

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
