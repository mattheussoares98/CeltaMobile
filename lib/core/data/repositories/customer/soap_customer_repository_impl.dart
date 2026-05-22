import 'package:celta_inventario/core/domain/entities/customer/soap/soap_customer_entity.dart';

import 'package:celta_inventario/core/domain/entities/customer/soap/search_customer_type.dart';

import 'package:celta_inventario/core/data/datasource/customer/customer.dart';
import 'package:celta_inventario/core/domain/repositories/customer/customer.dart';

class SoapCustomerRepositoryImpl implements ISoapCustomerRepository {
  final ISoapCustomerDatasource datasource;
  SoapCustomerRepositoryImpl(this.datasource);

  @override
  Future<List<SoapCustomerEntity>> loadCustomer({
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
