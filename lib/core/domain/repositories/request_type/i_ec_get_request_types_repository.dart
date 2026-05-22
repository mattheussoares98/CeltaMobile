import 'package:celta_inventario/core/domain/entities/entities.dart';

abstract class IEcGetRequestTypesRepository {
  Future<List<BSFRequestTypeEntity>> search({
    required EcRequestTypeParametersEntity parameters,
    required EcRequestParams params,
  });
}
