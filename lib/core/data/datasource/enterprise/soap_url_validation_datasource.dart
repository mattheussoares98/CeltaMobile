import 'dart:async';
import 'dart:convert';

import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'package:celta_inventario/core/data/datasource/enterprise/enterprise.dart';

class SoapUrlValidationDatasource implements ISoapUrlValidationDatasource {
  final SoapRequest soapRequest;

  SoapUrlValidationDatasource(this.soapRequest);

  @override
  Future<String> findWorkingUrl(List<String> urls) async {
    final cleanUrls = urls
        .where((u) => u.removeWhiteSpaces().isNotEmpty)
        .toList();

    final exception = AppException.localized(CoreFailure.noWorkingUrl);
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
