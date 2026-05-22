import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class ILoadAddressByCepRepository {
  Future<AddressEntity?> get(String cep);
}
