import '../../entities/entities.dart';

abstract class ISoapLoadSupplierRepository {
  Future<List<SupplierEntity>> load({
    required String workingUrl,
    required String crossIdentity,
    required SearchSupplierType searchType,
    required String searchValue,
  });
}
