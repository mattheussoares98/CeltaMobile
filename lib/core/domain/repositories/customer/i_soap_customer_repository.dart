import '../../entities/customer/customer.dart';

abstract class ISoapCustomerRepository {
  Future<List<CustomerEntity>> loadCustomer({
    required SearchCustomerType searchType,
    required String searchValue,
    required String crossIdentity,
    required int enterpriseCode,
    required String urlInUse,
  });
}
