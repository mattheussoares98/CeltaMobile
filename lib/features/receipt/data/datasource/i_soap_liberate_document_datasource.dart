abstract class ISoapLiberateDocumentDatasource {
  Future<void> liberate({
    required String baseUrl,
    required String crossIdentity,
    required int CodigoInterno_ProcRecebDoc,
  });
}
