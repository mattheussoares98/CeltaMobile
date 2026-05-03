import 'package:celta_inventario/features/buy_request/domain/entities/pending_buy_request_entity.dart';

import '../datasource/datasource.dart';
import '../models/models.dart';
import 'package:celta_inventario/features/buy_request/domain/repository/repository.dart';

class LocalPendingBuyRequestRepositoryImpl
    implements ILocalPendingBuyRequestRepository {
  final ILocalPendingBuyRequestDatasource datasource;
  LocalPendingBuyRequestRepositoryImpl(this.datasource);

  @override
  Future<PendingBuyRequestEntity?> load(int enterpriseCode) async {
    final response = await datasource.load(enterpriseCode);

    return response?.toEntity();
  }

  @override
  Future<void> update(
    PendingBuyRequestEntity entity,
    int enterpriseCode,
  ) async {
    await datasource.update(
      PendingBuyRequestModel.fromEntity(entity),
      enterpriseCode,
    );
  }
}
