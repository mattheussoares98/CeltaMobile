abstract class ISoapUpdateObservationsDatasource {
  Future<void> update({
    required String baseUrl,
    required String crossIdentity,
    required int CodigoInterno_ProcRecebDoc,
    required String observations,
  });
}
