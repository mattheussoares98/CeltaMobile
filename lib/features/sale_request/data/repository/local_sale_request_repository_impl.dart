import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

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
