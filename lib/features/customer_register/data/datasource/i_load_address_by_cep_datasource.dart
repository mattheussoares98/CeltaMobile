import '../../../../core/data/models/models.dart';

abstract class ILoadAddressByCepDatasource {
  Future<AddressModel?> get(String cep);
}
