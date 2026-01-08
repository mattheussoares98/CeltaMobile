abstract class ISoapInventoryAnnulRepository {
  Future<void> annul({
    required String workingUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int codigoInternoProEmb,
  });
}
