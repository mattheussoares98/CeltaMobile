import '../../../../core/data/models/customer/customer.dart';

abstract class ISoapInsertUpdateCustomerDatasource {
  Future<void> insertOrUpdateCustomer({
    required CustomerModel customer,
    required String workingUrl,
    required String crossIdentity,
  });
}
