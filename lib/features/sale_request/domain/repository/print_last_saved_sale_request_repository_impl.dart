import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

class PrintLastSavedSaleRequestRepositoryImpl
    implements IPrintLastSavedSaleRequestRepository {
  final IPrintLastSavedSaleRequestDatasource datasource;
  PrintLastSavedSaleRequestRepositoryImpl(this.datasource);

  @override
  Future<void> print({
    required LastSavedSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  }) async {
    await datasource.print(
      saleRequest: SoapLastSavedSaleRequestModel.fromEntity(saleRequest),
      ip: ip,
      userName: userName,
    );
  }
}
