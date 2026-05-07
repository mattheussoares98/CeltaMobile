import '../../../domain/entities/entities.dart';
import '../../models/models.dart';

abstract class IEcGetRequestTypesDatasource {
  Future<List<BSFRequestTypeModel>> search({
    required EcRequestTypeParametersEntity parameters,
    required EcRequestParams params,
  });
}
