abstract class SoapRequest {
  Future<dynamic> post({
    required String url,
    required String typeOfResponse,
    required String? typeOfResult,
    required String soapAction,
    required String serviceASMX,
    required Map<String, dynamic> parameters,
  });
}
