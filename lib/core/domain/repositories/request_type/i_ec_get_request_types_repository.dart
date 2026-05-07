import '../../entities/entities.dart';

abstract class IEcGetRequestTypesRepository {
  Future<List<BSFRequestTypeEntity>> search({
    required EcRequestTypeParametersEntity parameters,
    required int enterpriseCode,
    required EcRequestParams params,
  });
}
