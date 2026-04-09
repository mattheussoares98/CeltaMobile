import '../../../domain/entities/entities.dart';
import '../../models/models.dart';

abstract class IEcGetRequestTypesDatasource {
  Future<List<BSFRequestTypeModel>> search({
    required BSFSearchRequestTypeParametersEntity parameters,
    required int enterpriseCode,
    required EcRequestParams params,
  });
}
