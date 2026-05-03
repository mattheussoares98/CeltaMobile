import '../datasource/datasource.dart';
import '../models/models.dart';
import 'package:celta_inventario/features/transfer_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/transfer_request/domain/repositories/repositories.dart';

class SoapInsertTransferRequestRepositoryImpl
    implements ISoapInsertTransferRequestRepository {
  ISoapInsertTransferRequestDatasource datasource;
  SoapInsertTransferRequestRepositoryImpl(this.datasource);

  @override
  Future<String> save({
    required String workingUrl,
    required String crossIdentity,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
    required List<TransferRequestProductItemEntity> products,
  }) async {
    return await datasource.save(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      enterpriseOriginCode: enterpriseOriginCode,
      enterpriseDestinyCode: enterpriseDestinyCode,
      requestTypeCode: requestTypeCode,
      products: products
          .map((e) => TransferRequestProductItemModel.fromEntity(e))
          .toList(),
    );
  }
}
