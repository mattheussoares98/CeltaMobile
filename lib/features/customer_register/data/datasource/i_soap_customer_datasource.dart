import '../../domain/entities/entities.dart';
import '../models/models.dart';

abstract class ISoapCustomerDatasource {
  Future<List<CustomerModel>> loadCustomer({
    required SearchCustomerType searchType,
    required String searchValue,
    required String crossIdentity,
    required int enterpriseCode,
    required String baseUrl,
  });
}
