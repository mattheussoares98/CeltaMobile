import 'package:celta_intelligence/core/domain/entities/customer/customer_entity.dart';

import '../../../../core/data/models/customer/customer.dart';
import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapInsertUpdateCustomerRepositoryImpl
    implements ISoapInsertUpdateCustomerRepository {
  final ISoapInsertUpdateCustomerDatasource datasource;
  SoapInsertUpdateCustomerRepositoryImpl(this.datasource);

  @override
  Future<void> insertOrUpdateCustomer({
    required CustomerEntity customer,
    required String baseUrl,
    required String crossIdentity,
  }) async {
    await datasource.insertOrUpdateCustomer(
      customer: CustomerModel.fromEntity(customer),
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
    );
  }
}
