import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/customer_register/domain/entities/entities.dart';

abstract class IEcGlobalParametersRepository {
  Future<BSFGlobalParametersEntity> getGlobalParameters(EcRequestParams params);
}
