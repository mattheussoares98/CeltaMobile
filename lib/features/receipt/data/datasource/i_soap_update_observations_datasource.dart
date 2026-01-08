abstract class ISoapUpdateObservationsDatasource {
  Future<void> update({
    required String workingUrl,
    required String crossIdentity,
    required int CodigoInterno_ProcRecebDoc,
    required String observations,
  });
}
