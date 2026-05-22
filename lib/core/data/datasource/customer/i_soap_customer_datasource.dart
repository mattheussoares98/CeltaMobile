import 'package:celta_inventario/core/domain/entities/customer/customer.dart';
import 'package:celta_inventario/core/data/models/customer/customer.dart';

abstract class ISoapCustomerDatasource {
  Future<List<SoapCustomerModel>> loadCustomer({
    required SearchCustomerType searchType,
    required String searchValue,
    required String crossIdentity,
    required int enterpriseCode,
    required String workingUrl,
  });
}
