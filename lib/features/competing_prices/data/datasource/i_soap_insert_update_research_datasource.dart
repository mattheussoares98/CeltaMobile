abstract class ISoapInsertUpdateResearchDatasource {
  Future<void> insertUpdate({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String name,
    required int researchCode,
    required Map<String, dynamic> associateConcurrentParams,
    String? observations,
  });
}
