abstract class ISoapInventoryEntryQuantityDatasource {
  Future<void> entry({
    required String urlInUse,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int productPackingCode,
    required double quantity,
    required bool isSubtract,
  });
}
