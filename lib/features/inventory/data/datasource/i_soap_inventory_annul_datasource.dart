abstract class ISoapInventoryAnnulDatasource {
  Future<void> annul({
    required String urlInUse,
    required String crossIdentity,
    required int codigoInternoInvCont,
    required int codigoInternoProEmb,
  });
}
