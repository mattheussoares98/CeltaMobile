abstract class ISoapInventoryAnnulDatasource {
  Future<void> annul({
    required String workingUrl,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int codigoInternoProEmb,
  });
}
