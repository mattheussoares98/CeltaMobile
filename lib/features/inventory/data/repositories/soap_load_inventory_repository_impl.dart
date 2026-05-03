import 'package:celta_inventario/features/inventory/domain/entities/inventory_entity.dart';

import '../datasource/datasource.dart';
import 'package:celta_inventario/features/inventory/domain/repositories/repositories.dart';

class SoapLoadInventoryRepositoryImpl implements ISoapLoadInventoryRepository {
  final ISoapLoadInventoryDatasource datasource;
  SoapLoadInventoryRepositoryImpl(this.datasource);

  @override
  Future<InventoryEntity> load({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await datasource.load(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    return response.toEntity();
  }
}
