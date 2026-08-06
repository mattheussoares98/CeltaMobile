import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/customer/customer.dart';

abstract class IEcCustomersDatasource {
  Future<List<BSFCustomerModel>> searchForMobileApp(
    EcGetCustomersParams params,
  );
}
