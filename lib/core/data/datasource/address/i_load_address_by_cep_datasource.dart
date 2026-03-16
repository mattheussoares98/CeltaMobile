import '../../models/models.dart';

abstract class ILoadAddressByCepDatasource {
  Future<SoapAddressModel?> get(String cep);
}
