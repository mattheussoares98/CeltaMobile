import '../../data/datasource/datasource.dart';
import '../../data/models/models.dart';
import '../entities/entities.dart';
import 'repository.dart';

class PrintSaleRequestRepositoryImpl implements IPrintSaleRequestRepository {
  final IPrintSoapLastSavedSaleRequestDatasource datasource;
  PrintSaleRequestRepositoryImpl(this.datasource);

  @override
  Future<void> soapPrint({
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
