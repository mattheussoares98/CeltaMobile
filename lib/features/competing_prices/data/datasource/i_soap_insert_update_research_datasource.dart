abstract class ISoapInsertUpdateResearchDatasource {
  Future<void> insertUpdate({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String name,
    int? researchCode,
    String? observations,
  });
}
