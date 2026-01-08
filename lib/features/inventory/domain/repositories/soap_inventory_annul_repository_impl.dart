import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapInventoryAnnulRepositoryImpl
    implements ISoapInventoryAnnulRepository {
  final ISoapInventoryAnnulDatasource datasource;
  SoapInventoryAnnulRepositoryImpl(this.datasource);

  @override
  Future<void> annul({
    required String urlInUse,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int codigoInternoProEmb,
  }) async {
    await datasource.annul(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      codigoInternoProEmb: codigoInternoProEmb,
    );
  }
}
