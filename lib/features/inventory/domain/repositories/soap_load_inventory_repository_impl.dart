import 'package:celta_intelligence/features/inventory/domain/entities/inventory_entity.dart';

import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapLoadInventoryRepositoryImpl implements ISoapLoadInventoryRepository {
  final ISoapLoadInventoryDatasource datasource;
  SoapLoadInventoryRepositoryImpl(this.datasource);

  @override
  Future<InventoryEntity> load({
    required String urlInUse,
    required String crossIdentity,
    required int enterpriseCode,
  }) async {
    final response = await datasource.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
    );

    return response.toEntity();
  }
}
