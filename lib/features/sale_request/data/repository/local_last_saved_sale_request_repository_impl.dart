import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

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
