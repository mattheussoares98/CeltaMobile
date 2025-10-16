import '../../../../core/domain/entities/entities.dart';
import '../models/models.dart';

abstract class ISoapInventoryProductsDatasource {
  Future<List<InventoryProductModel>> load({
    required String baseUrl,
    required String searchValue,
    required int codigoInternoInventario,
    required SearchType searchType,
    required String crossIdentity,
    required int enterpriseCode,
    required int codigoInternoInvCont,
    required EnterpriseEntity selectedEnterprise,
  });
}
