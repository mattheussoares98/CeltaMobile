import '../entities/entities.dart';

abstract class ISoapLoadCovenantsRepository {
  Future<List<CovenantEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required SearchCovenantType searchCovenantType,
    required String searchValue,
  });
}
