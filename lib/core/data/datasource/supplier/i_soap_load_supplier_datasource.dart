import '../../../domain/entities/entities.dart';
import '../../models/models.dart';

abstract class ISoapLoadSupplierDatasource {
  Future<List<SupplierModel>> load({
    required String urlInUse,
    required String crossIdentity,
    required SearchSupplierType searchType,
    required String searchValue,
  });
}
