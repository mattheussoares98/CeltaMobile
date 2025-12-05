abstract class ISoapUpdateProductDatasource {
  Future<void> update({
    required String baseUrl,
    required Map<String, dynamic> parametersPayload,
  });
}
