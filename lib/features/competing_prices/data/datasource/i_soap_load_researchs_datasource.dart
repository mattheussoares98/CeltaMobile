import '../models/models.dart';

abstract class ISoapLoadResearchsDatasource {
  Future<List<ResearchModel>> load({
    required String crossIdentity,
    required String baseUrl,
    required int enterpriseCode,
    String? searchValue,
  });
}
