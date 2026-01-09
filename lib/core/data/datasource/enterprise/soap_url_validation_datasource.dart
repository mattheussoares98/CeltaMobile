import 'dart:async';
import 'dart:convert';

import 'package:celta_intelligence/localization/string_hardcoded.dart';

import '../../../../exceptions/exceptions.dart';
import '../../../../utils/utils.dart';
import '../../../domain/contracts/contracts.dart';
import '../../../domain/errors/errors.dart';
import 'enterprise.dart';

class SoapUrlValidationDatasource implements ISoapUrlValidationDatasource {
  final SoapRequest soapRequest;

  SoapUrlValidationDatasource(this.soapRequest);

  @override
  Future<String> findWorkingUrl(List<String> urls) async {
    final cleanUrls = urls
        .where((u) => u.removeWhiteSpaces().isNotEmpty)
        .toList();

    final exception = AppException(
      'Nenhuma URL está funcionando. Verifique sua conexão com a internet e caso esteja funcionando, entre em contato com o suporte técnico'
          .hardcoded,
    );
    if (cleanUrls.isEmpty) {
      throw exception;
    }

    final completer = Completer<String>();
    int failedAttempts = 0;

    for (final url in cleanUrls) {
      _testUrlConnectivity(url)
          .then((result) {
            if (completer.isCompleted) return;

            if (result != null) {
              // Success: complete with the working URL
              completer.complete(result);
            } else {
              // Failure: increment counter and check if all have failed
              failedAttempts++;
              if (failedAttempts == cleanUrls.length) {
                completer.completeError(exception);
              }
            }
          })
          .catchError((_) {
            if (completer.isCompleted) return;

            failedAttempts++;
            if (failedAttempts == cleanUrls.length) {
              completer.completeError(exception);
            }
          });
    }

    return completer.future;
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
