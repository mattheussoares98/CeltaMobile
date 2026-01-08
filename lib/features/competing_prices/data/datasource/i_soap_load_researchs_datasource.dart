import '../models/models.dart';

abstract class ISoapLoadResearchsDatasource {
  Future<List<ResearchModel>> load({
    required String crossIdentity,
    required String urlInUse,
    required int enterpriseCode,
    String? searchValue,
  });
}
