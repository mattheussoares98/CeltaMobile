import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcCustomersRepository {
  Future<List<BSFCustomerEntity>> searchForMobileApp({
    required EcRequestParams params,
    required String searchValue,
    required int enterpriseCode,
    required bool searchByPersonalizedCode,
  });
}
