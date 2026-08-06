import 'package:celta_inventario/core/data/datasource/customer/customer.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/domain/repositories/customer/customer.dart';

class EcCustomersRepositoryImpl implements IEcCustomersRepository {
  final IEcCustomersDatasource datasource;

  EcCustomersRepositoryImpl(this.datasource);

  @override
  Future<List<BSFCustomerEntity>> searchForMobileApp(
    EcGetCustomersParams params,
  ) async {
    final result = await datasource.searchForMobileApp(params);

    return result.map((e) => e.toEntity()).toList();
  }
}
