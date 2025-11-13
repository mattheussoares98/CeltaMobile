import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

class PrintLastSavedSaleRequestRepositoryImpl
    implements IPrintLastSavedSaleRequestRepository {
  final IPrintLastSavedSaleRequestDatasource datasource;
  PrintLastSavedSaleRequestRepositoryImpl(this.datasource);

  @override
  Future<bool> printReceiptDirectly({
    required LastSavedSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  }) async {
    return await datasource.print(
      saleRequest: LastSavedSaleRequestModel.fromEntity(saleRequest),
      ip: ip,
      userName: userName,
    );
  }
}
