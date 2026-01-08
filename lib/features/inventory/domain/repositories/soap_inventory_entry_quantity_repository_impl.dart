import '../../data/datasource/datasource.dart';
import 'repositories.dart';

class SoapInventoryEntryQuantityRepositoryImpl
    implements ISoapInventoryEntryQuantityRepository {
  final ISoapInventoryEntryQuantityDatasource datasource;
  SoapInventoryEntryQuantityRepositoryImpl(this.datasource);

  @override
  Future<void> entry({
    required String urlInUse,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int productPackingCode,
    required double quantity,
    required bool isSubtract,
  }) async {
    await datasource.entry(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      productPackingCode: productPackingCode,
      quantity: quantity,
      isSubtract: isSubtract,
    );
  }
}
