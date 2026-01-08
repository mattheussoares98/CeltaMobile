abstract class ISoapLiberateDocumentDatasource {
  Future<void> liberate({
    required String workingUrl,
    required String crossIdentity,
    required int CodigoInterno_ProcRecebDoc,
  });
}
