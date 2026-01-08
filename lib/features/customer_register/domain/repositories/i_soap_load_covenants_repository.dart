import '../entities/entities.dart';

abstract class ISoapLoadCovenantsRepository {
  Future<List<CovenantEntity>> load({
    required String urlInUse,
    required String crossIdentity,
    required SearchCovenantType searchCovenantType,
    required String searchValue,
  });
}
