import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapInventoryAnnulRepositoryImpl
    implements ISoapInventoryAnnulRepository {
  final ISoapInventoryAnnulDatasource datasource;
  SoapInventoryAnnulRepositoryImpl(this.datasource);

  @override
  Future<void> annul({
    required String baseUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int productPackingCode,
  }) async {
    await datasource.annul(
      baseUrl: baseUrl,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      productPackingCode: productPackingCode,
    );
  }
}
