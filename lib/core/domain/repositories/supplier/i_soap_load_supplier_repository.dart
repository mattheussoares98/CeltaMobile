import '../../entities/entities.dart';

abstract class ISoapLoadSupplierRepository {
  Future<List<SupplierEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required SearchSupplierType searchType,
    required String searchValue,
  });
}
