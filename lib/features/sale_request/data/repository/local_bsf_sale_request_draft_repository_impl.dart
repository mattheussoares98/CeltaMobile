import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

class LocalBSFSaleRequestDraftRepositoryImpl implements ILocalBSFSaleRequestDraftRepository {
  final ILocalBSFSaleRequestDraftDatasource datasource;
  LocalBSFSaleRequestDraftRepositoryImpl(this.datasource);

  @override
  Future<void> save(
    BSFSaleRequestEntity value, {
    required int enterpriseCode,
    required int requestTypeCode,
  }) async {
    await datasource.save(
      BSFSaleRequestModel.fromEntity(value),
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
    );
  }

  @override
  Future<BSFSaleRequestEntity?> load({
    required int enterpriseCode,
    required int requestTypeCode,
  }) async {
    final response = await datasource.load(
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
    );
    return response?.toEntity();
  }

  @override
  Future<void> clear({
    required int enterpriseCode,
    required int requestTypeCode,
  }) async {
    await datasource.clear(
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
    );
  }
}
