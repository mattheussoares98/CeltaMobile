import '../../entities/entities.dart';

abstract class IEcGetRequestTypesRepository {
  Future<List<BSFRequestTypeEntity>> search({
    required BSFSearchRequestTypeParametersEntity parameters,
    required int enterpriseCode,
    required EcRequestParams params,
  });
}
