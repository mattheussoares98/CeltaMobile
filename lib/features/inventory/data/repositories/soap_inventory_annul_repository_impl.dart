import 'package:celta_inventario/features/inventory/data/datasource/datasource.dart';
import 'package:celta_inventario/features/inventory/domain/repositories/repositories.dart';

class SoapInventoryAnnulRepositoryImpl
    implements ISoapInventoryAnnulRepository {
  final ISoapInventoryAnnulDatasource datasource;
  SoapInventoryAnnulRepositoryImpl(this.datasource);

  @override
  Future<void> annul({
    required String workingUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int codigoInternoProEmb,
  }) async {
    await datasource.annul(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      codigoInternoProEmb: codigoInternoProEmb,
    );
  }
}
