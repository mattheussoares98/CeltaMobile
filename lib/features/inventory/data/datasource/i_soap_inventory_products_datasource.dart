import '../../../../core/data/models/models.dart';
import '../../../../core/domain/entities/entities.dart';

abstract class ISoapInventoryProductsDatasource {
  Future<List<InventoryProductModel>> load({
    //TODO delete this datasource
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
