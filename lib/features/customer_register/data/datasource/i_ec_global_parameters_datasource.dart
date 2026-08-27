import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/data/models/models.dart';

abstract class IEcGlobalParametersDatasource {
  Future<BSFGlobalParametersModel> getGlobalParameters(EcRequestParams params);
}
