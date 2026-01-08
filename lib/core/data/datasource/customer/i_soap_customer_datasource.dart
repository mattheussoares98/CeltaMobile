import '../../../domain/entities/customer/customer.dart';
import '../../models/customer/customer.dart';

abstract class ISoapCustomerDatasource {
  Future<List<CustomerModel>> loadCustomer({
    required SearchCustomerType searchType,
    required String searchValue,
    required String crossIdentity,
    required int enterpriseCode,
    required String workingUrl,
  });
}
