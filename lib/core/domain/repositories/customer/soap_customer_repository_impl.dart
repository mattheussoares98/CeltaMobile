import 'package:celta_inventario/core/domain/entities/customer/customer_entity.dart';

import 'package:celta_inventario/core/domain/entities/customer/search_customer_type.dart';

import '../../../data/datasource/customer/customer.dart';
import 'customer.dart';

class SoapCustomerRepositoryImpl implements ISoapCustomerRepository {
  final ISoapCustomerDatasource datasource;
  SoapCustomerRepositoryImpl(this.datasource);

  @override
  Future<List<CustomerEntity>> loadCustomer({
    required SearchCustomerType searchType,
    required String searchValue,
    required String crossIdentity,
    required int enterpriseCode,
    required String workingUrl,
  }) async {
    final result = await datasource.loadCustomer(
      searchType: searchType,
      searchValue: searchValue,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      workingUrl: workingUrl,
    );

    return result.map((e) => e.toEntity()).toList();
  }
}
