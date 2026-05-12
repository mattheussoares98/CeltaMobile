import '../../../../core/domain/entities/entities.dart';

abstract class ISoapInsertUpdateCustomerRepository {
  Future<void> insertOrUpdateCustomer({
    required SoapCustomerEntity customer,
    required String workingUrl,
    required String crossIdentity,
  });
}
