import 'dart:convert';

import '../../../../utils/utils.dart';
import '../../../domain/contracts/contracts.dart';
import '../../../domain/errors/errors.dart';
import 'enterprise.dart';

class SoapUrlValidationDatasource implements ISoapUrlValidationDatasource {
  final SoapRequest soapRequest;

  SoapUrlValidationDatasource(this.soapRequest);

  @override
  Future<String?> findWorkingUrl(List<String> urls) async {
    final cleanUrls = urls
        .where((u) => u.removeWhiteSpaces().isNotEmpty)
        .toList();
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
      await soapRequest
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
    } catch (e) {
      if (e is HttpError) {
        return url;
      }
    }
    return null;
  }
}
