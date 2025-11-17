import '../entities/entities.dart';

abstract class ISoapLoadResearchsRepository {
  Future<List<ResearchEntity>> load({
    required String crossIdentity,
    required String baseUrl,
    required int enterpriseCode,
    String? searchValue,
  });
}
