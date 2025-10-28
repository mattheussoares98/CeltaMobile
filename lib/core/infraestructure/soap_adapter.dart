import 'dart:convert';
import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:http/http.dart';
import 'package:xml2json/xml2json.dart';

import '../domain/contracts/contracts.dart' as contracts;
import '../domain/errors/errors.dart';

class SoapAdapter implements contracts.SoapRequest {
  final Client client;

  SoapAdapter(this.client);

  @override
  Future<dynamic> post({
    required String url,
    required String typeOfResponse,
    required String? typeOfResult,
    required String soapAction,
    required String serviceASMX,
    required Map<String, dynamic> parameters,
  }) async {
    try {
      final soapHeaders = {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://celtaware.com.br/$soapAction',
        'Accept-Language': 'en-US',
        'Access-Control-Allow-Methods': '*',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': '*',
      };

      String parameterTags = '';

      parameters.forEach((tag, value) {
        parameterTags += '<$tag>$value</$tag>\n';
      });

      final envelope =
          '''<?xml version="1.0" encoding="utf-8"?>
      <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
        <soap12:Body>
          <$soapAction xmlns="http://celtaware.com.br/">
          $parameterTags
          </$soapAction>
        </soap12:Body>
      </soap12:Envelope>''';

      final response = await client
          .post(
            Uri.parse('$url/ccs/$serviceASMX'),
            body: envelope,
            headers: soapHeaders,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw HttpError.serverError(response.body);
      }

      final Xml2Json xml2json = Xml2Json();
      xml2json.parse(response.body);
      final parsedJson = json.decode(xml2json.toParker());

      final responseBody =
          parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse];

      if (responseBody["status"] == "OK") {
        return _handleSuccessResponse(responseBody, typeOfResult);
      } else if (responseBody["status"].contains("sucesso")) {
        return _handleSuccessResponse(responseBody, typeOfResult);
      } else {
        throw BsError(responseBody["status"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  dynamic _handleSuccessResponse(
    Map<String, dynamic> responseBody,
    String? typeOfResult,
  ) {
    if (responseBody.containsKey('status') && typeOfResult == null) {
      return responseBody['status'];
    } else if (typeOfResult == null) {
      return 'Sucesso'.hardcoded;
    } else if (responseBody[typeOfResult] != null) {
      if (_isValidResponse(responseBody, typeOfResult)) {
        return responseBody[typeOfResult]["diffgr:diffgram"]["NewDataSet"];
      }
      return responseBody[typeOfResult].toString();
    } else if (responseBody.toString().contains("sucesso")) {
      return responseBody["status"][typeOfResult];
    }
    throw BsError('Estrutura da resposta inválida');
  }

  bool _isValidResponse(
    Map<String, dynamic> responseBody,
    String typeOfResult,
  ) {
    try {
      if (responseBody[typeOfResult] == null) {
        return false;
      } else if (responseBody[typeOfResult]?["diffgr:diffgram"] == null) {
        return false;
      } else if (responseBody[typeOfResult]?["diffgr:diffgram"]?["NewDataSet"] ==
          null) {
        return false;
      }
      return responseBody[typeOfResult]?["diffgr:diffgram"]?["NewDataSet"] !=
          null;
    } catch (e) {
      return false;
    }
  }
}
