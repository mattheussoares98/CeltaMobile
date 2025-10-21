import 'package:celta_intelligence/features/buy_request/domain/entities/pending_buy_request_entity.dart';

import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import 'repository.dart';

class LocalPendingBuyRequestRepositoryImpl
    implements ILocalPendingBuyRequestRepository {
  final ILocalPendingBuyRequestDatasource datasource;
  LocalPendingBuyRequestRepositoryImpl(this.datasource);

  @override
  Future<PendingBuyRequestEntity?> load() async {
    final response = await datasource.load();

    return response?.toEntity();
  }

  @override
  Future<void> update(PendingBuyRequestEntity entity) async {
    await datasource.update(PendingBuyRequestModel.fromEntity(entity));
  }
}
