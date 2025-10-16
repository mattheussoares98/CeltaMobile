import '../../../../core/domain/entities/entities.dart';
import '../entities/entities.dart';

abstract class ISoapInventoryProductsRepository {
  Future<List<InventoryProductEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required String searchValue,
    required int codigoInternoInventario,
    required SearchType searchType,
    required int codigoInternoInvCont,
    required EnterpriseEntity selectedEnterprise,
  });
}
