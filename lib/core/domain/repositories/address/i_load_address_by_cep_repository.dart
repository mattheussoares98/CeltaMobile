import '../../entities/entities.dart';

abstract class ILoadAddressByCepRepository {
  Future<AddressEntity?> get(String cep);
}
