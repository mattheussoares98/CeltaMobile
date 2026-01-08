import '../entities/entities.dart';

abstract class ISoapInsertUpdateResearchRepository {
  Future<void> insertUpdate({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String name,
    ConcurrentEntity? concurrentToAssociate,
    int? researchCode,
    String? observations,
  });
}
