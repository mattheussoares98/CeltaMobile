import 'package:celta_inventario/core/domain/entities/customer/customer.dart';

abstract class ISoapCustomerRepository {
  Future<List<SoapCustomerEntity>> loadCustomer({
    required SearchCustomerType searchType,
    required String searchValue,
    required String crossIdentity,
    required int enterpriseCode,
    required String workingUrl,
  });
}
