import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/models/models.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';

class PrintSaleRequestRepositoryImpl implements IPrintSaleRequestRepository {
  final IPrintSoapLastSavedSaleRequestDatasource soapPrintDatasource;
  final IPrintBSFSaleRequestDatasource bsfDatasource;
  PrintSaleRequestRepositoryImpl(this.soapPrintDatasource, this.bsfDatasource);

  @override
  Future<void> soapPrint({
    required LastSavedSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  }) async {
    await soapPrintDatasource.print(
      saleRequest: SoapLastSavedSaleRequestModel.fromEntity(saleRequest),
      ip: ip,
      userName: userName,
    );
  }

  @override
  Future<void> bsfPrint({
    required BSFSaleRequestEntity saleRequest,
    required String ip,
    required String userName,
  }) async {
    await bsfDatasource.print(
      saleRequest: BSFSaleRequestModel.fromEntity(saleRequest),
      ip: ip,
      userName: userName,
    );
  }
}
