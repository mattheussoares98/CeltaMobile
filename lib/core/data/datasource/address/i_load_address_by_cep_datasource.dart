import 'package:celta_inventario/core/data/models/models.dart';

abstract class ILoadAddressByCepDatasource {
  Future<SoapAddressModel?> get(String cep);
}
