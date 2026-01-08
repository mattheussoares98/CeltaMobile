import 'dart:convert';

import '../../../domain/contracts/contracts.dart';
import 'enterprise.dart';

class SoapUrlValidationDatasource implements ISoapUrlValidationDatasource {
  final SoapRequest soapRequest;

  SoapUrlValidationDatasource(this.soapRequest);

  @override
  Future<String?> findWorkingUrl(List<String> urls) async {
    //TODO create tests
    final cleanUrls = urls.where((u) => u.isNotEmpty).toList();
    if (cleanUrls.isEmpty) return null;

    final results = await Future.wait(
      cleanUrls.map((url) => _testUrlConnectivity(url)),
    );

    try {
      return results.firstWhere((url) => url != null);
    } catch (_) {
      return null;
    }
  }

  Future<String?> _testUrlConnectivity(String url) async {
    try {
      final response = await soapRequest
          .post(
            url: url,
            parameters: {
              "jsonParameters": json.encode({
                "CrossIdentity": 'crossIdentity',
                "ResourceCode": 0,
                "RoutineInt": 0,
              }),
            },
            typeOfResponse: "UserCanAccessCrossResourceResponse",
            soapAction: "UserCanAccessCrossResource",
            serviceASMX: "CeltaSecurityService.asmx",
            typeOfResult: "UserCanAccessCrossResourceResult",
          )
          .timeout(const Duration(seconds: 10));

      if (response.isNotEmpty) {
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
