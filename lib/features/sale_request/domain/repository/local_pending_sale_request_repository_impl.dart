import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

class LocalPendingSaleRequestRepositoryImpl
    implements ILocalPendingSaleRequestRepository {
  final ILocalPendingSaleRequestDatasource datasource;
  LocalPendingSaleRequestRepositoryImpl(this.datasource);

  @override
  Future<PendingSaleRequestEntity?> load(int enterpriseCode) async {
    final response = await datasource.load(enterpriseCode);

    return response?.toEntity();
  }

  @override
  Future<void> save(PendingSaleRequestEntity value, int enterpriseCode) async {
    await datasource.save(
      PendingSaleRequestModel.fromEntity(value),
      enterpriseCode,
    );
  }

  @override
  Future<void> clear(int enterpriseCode) async {
    await datasource.clear(enterpriseCode);
  }
}
