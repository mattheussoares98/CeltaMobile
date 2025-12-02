import 'package:celta_intelligence/core/domain/entities/enterprise/enterprise_entity.dart';

import 'package:celta_intelligence/core/domain/entities/product/search_type.dart';

import 'package:celta_intelligence/core/domain/entities/product/inventory_product_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapInventoryProductsRepositoryImpl
    implements ISoapInventoryProductsRepository {
  final ISoapInventoryProductsDatasource datasource;
  SoapInventoryProductsRepositoryImpl(this.datasource);

  @override
  Future<List<InventoryProductEntity>> load({
    required String baseUrl,
    required String searchValue,
    required int codigoInternoInventario,
    required SearchType searchType,
    required String crossIdentity,
    required int enterpriseCode,
    required int codigoInternoInvCont,
    required EnterpriseEntity selectedEnterprise,
  }) async {
    final response = await datasource.load(
      baseUrl: baseUrl,
      searchValue: searchValue,
      codigoInternoInventario: codigoInternoInventario,
      searchType: searchType,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      codigoInternoInvCont: codigoInternoInvCont,
      selectedEnterprise: selectedEnterprise,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
