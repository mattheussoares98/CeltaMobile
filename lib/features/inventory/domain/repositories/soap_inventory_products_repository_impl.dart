import 'package:celta_intelligence/core/domain/entities/enterprise/enterprise_entity.dart';

import 'package:celta_intelligence/core/domain/entities/product/search_type.dart';

import 'package:celta_intelligence/features/inventory/domain/entities/inventory_product_entity.dart';

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
    required int inventoryProcessCode,
    required SearchType searchType,
    required String crossIdentity,
    required int enterpriseCode,
    required int inventoryCountingCode,
    required EnterpriseEntity selectedEnterprise,
  }) async {
    final response = await datasource.load(
      baseUrl: baseUrl,
      searchValue: searchValue,
      inventoryProcessCode: inventoryProcessCode,
      searchType: searchType,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      inventoryCountingCode: inventoryCountingCode,
      selectedEnterprise: selectedEnterprise,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
