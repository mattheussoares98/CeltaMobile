abstract class ISoapInventoryAnnulRepository {
  Future<void> annul({
    required String baseUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int productPackingCode,
  });
}
