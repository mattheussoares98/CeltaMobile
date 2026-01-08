import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repositories.dart';

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
