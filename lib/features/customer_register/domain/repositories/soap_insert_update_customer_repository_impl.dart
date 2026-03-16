import 'package:celta_inventario/core/domain/entities/customer/customer_entity.dart';

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
    required String workingUrl,
    required String crossIdentity,
  }) async {
    await datasource.insertOrUpdateCustomer(
      customer: SoapCustomerModel.fromEntity(customer),
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
    );
  }
}
