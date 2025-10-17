abstract class ISoapInventoryEntryQuantityRepository {
  Future<void> entry({
    required String baseUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int productPackingCode,
    required double quantity,
    required bool isSubtract,
  });
}
