import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

class LocalSaleRequestRepositoryImpl implements ILocalSaleRequestRepository {
  final ILocalSaleRequestDatasource datasource;
  LocalSaleRequestRepositoryImpl(this.datasource);

  @override
  Future<SaleRequestEntity?> load(int enterpriseCode) async {
    final response = await datasource.load(enterpriseCode);

    return response?.toEntity();
  }

  @override
  Future<void> save(SaleRequestEntity value, int enterpriseCode) async {
    await datasource.save(
      SoapSaleRequestModel.fromEntity(value),
      enterpriseCode,
    );
  }

  @override
  Future<void> clear(int enterpriseCode) async {
    await datasource.clear(enterpriseCode);
  }
}
