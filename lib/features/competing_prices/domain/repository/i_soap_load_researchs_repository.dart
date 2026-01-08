import '../entities/entities.dart';

abstract class ISoapLoadResearchsRepository {
  Future<List<ResearchEntity>> load({
    required String crossIdentity,
    required String urlInUse,
    required int enterpriseCode,
    String? searchValue,
  });
}
