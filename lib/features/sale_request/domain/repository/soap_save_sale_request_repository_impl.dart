import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

class SoapSaveSaleRequestRepositoryImpl
    implements ISoapSaveSaleRequestRepository {
  final ISoapSaveSaleRequestDatasource datasource;
  SoapSaveSaleRequestRepositoryImpl(this.datasource);

  @override
  Future<String?> save({
    required String baseUrl,
    required String crossIdentity,
    required int enterpriseCode,
    required int requestTypeCode,
    required PendingSaleRequestEntity saleRequest,
  }) async {
    return await datasource.save(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      enterpriseCode: enterpriseCode,
      requestTypeCode: requestTypeCode,
      saleRequest: PendingSaleRequestModel.fromEntity(saleRequest),
    );
  }
}
