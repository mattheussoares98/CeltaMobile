import '../../../../core/domain/entities/entities.dart';

abstract class ISoapInsertUpdateCustomerRepository {
  Future<void> insertOrUpdateCustomer({
    required CustomerEntity customer,
    required String workingUrl,
    required String crossIdentity,
  });
}
