import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcCustomersRepository {
  Future<List<BSFCustomerEntity>> searchForMobileApp(
    EcGetCustomersParams params,
  );
}
