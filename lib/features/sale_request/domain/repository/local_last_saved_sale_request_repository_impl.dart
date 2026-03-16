import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

class LocalLastSavedSaleRequestRepositoryImpl
    implements ILocalLastSavedSaleRequestRepository {
  final ILocalLastSavedSaleRequestDatasource datasource;
  LocalLastSavedSaleRequestRepositoryImpl(this.datasource);

  @override
  Future<LastSavedSaleRequestEntity?> load(int enterpriseCode) async {
    final result = await datasource.load(enterpriseCode);

    return result?.toEntity();
  }

  @override
  Future<void> save({
    required LastSavedSaleRequestEntity value,
    required int enterpriseCode,
  }) async {
    await datasource.save(
      value: SoapLastSavedSaleRequestModel.fromEntity(value),
      enterpriseCode: enterpriseCode,
    );
  }
}
