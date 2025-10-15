import 'package:celta_intelligence/features/inventory/domain/entities/inventory_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapLoadInventoryRepositoryImpl implements ISoapLoadInventoryRepository {
  final ISoapLoadInventoryDatasource datasource;
  SoapLoadInventoryRepositoryImpl(this.datasource);

  @override
  Future<List<InventoryEntity>> load({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await datasource.load(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    return response.map((e) => e.toEntity()).toList();
  }
}
