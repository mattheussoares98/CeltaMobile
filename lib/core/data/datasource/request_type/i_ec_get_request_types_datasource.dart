import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/data/models/models.dart';

abstract class IEcGetRequestTypesDatasource {
  Future<List<BSFRequestTypeModel>> search({
    required EcRequestTypeParametersEntity parameters,
    required EcRequestParams params,
  });
}
