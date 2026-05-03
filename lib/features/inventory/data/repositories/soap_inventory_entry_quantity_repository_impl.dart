import '../datasource/datasource.dart';
import 'package:celta_inventario/features/inventory/domain/repositories/repositories.dart';

class SoapInventoryEntryQuantityRepositoryImpl
    implements ISoapInventoryEntryQuantityRepository {
  final ISoapInventoryEntryQuantityDatasource datasource;
  SoapInventoryEntryQuantityRepositoryImpl(this.datasource);

  @override
  Future<void> entry({
    required String workingUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int productPackingCode,
    required double quantity,
    required bool isSubtract,
  }) async {
    await datasource.entry(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      codigoInternoInvCont: codigoInternoInvCont,
      productPackingCode: productPackingCode,
      quantity: quantity,
      isSubtract: isSubtract,
    );
  }
}
