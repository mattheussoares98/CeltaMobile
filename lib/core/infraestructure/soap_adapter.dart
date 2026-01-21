import 'dart:convert';
import 'package:celta_inventario/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';
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
      };

      final soapEnvelope = _buildEnvelope(parameters, soapAction);

      // throw Exception();

      final response = await client
          .post(
            Uri.parse('$url/ccs/$serviceASMX'),
            body: soapEnvelope,
            headers: soapHeaders,
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw HttpError.serverError(response.body);
      }

      final parsedJson = await compute(_parseXmlCompute, response.body);

      final responseBody =
          parsedJson["soap:Envelope"]["soap:Body"][typeOfResponse];

      final status = responseBody["status"];
      if (status == "OK") {
        return _handleSuccessResponse(responseBody, typeOfResult);
      } else if (status.contains("sucesso")) {
        return _handleSuccessResponse(responseBody, typeOfResult);
      } else if (serviceASMX.toLowerCase() ==
          'CeltaSecurityService.asmx'.toLowerCase()) {
        return _handleSuccessResponse(responseBody, typeOfResult);
      } else {
        throw BsError(status);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Map<String, dynamic> _parseXmlCompute(String xmlBody) {
    final transformer = Xml2Json();
    transformer.parse(xmlBody);
    return json.decode(transformer.toParker());
  }

  String _buildEnvelope(Map<String, dynamic> params, String soapAction) {
    // Optimization: Use StringBuffer for complex SOAP bodies
    final buffer = StringBuffer();
    buffer.write('<?xml version="1.0" encoding="utf-8"?>');
    buffer.write(
      '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">',
    );
    buffer.write('<soap12:Body>');
    buffer.write('<$soapAction xmlns="http://celtaware.com.br/">');
    params.forEach((key, value) => buffer.write('<$key>$value</$key>'));
    buffer.write('</$soapAction>');
    buffer.write('</soap12:Body>');
    buffer.write('</soap12:Envelope>');
    return buffer.toString();
  }

  dynamic _handleSuccessResponse(
    Map<String, dynamic> responseBody,
    String? typeOfResult,
  ) {
    if (responseBody.containsKey('status') && typeOfResult == null) {
      return responseBody['status'];
    } else if (responseBody.containsKey('status') &&
        !responseBody.containsKey(typeOfResult)) {
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
    } else if (responseBody.toString().toLowerCase().contains('ok')) {
      return null; //only return that has worked
    }
    throw BsError('Estrutura da resposta inválida');
  }

  bool _isValidResponse(
    Map<String, dynamic> responseBody,
    String typeOfResult,
  ) {
    try {
      final result = responseBody[typeOfResult];
      if (result == null) return false;

      final diffgram = result["diffgr:diffgram"];
      if (diffgram == null) return false;

      return diffgram["NewDataSet"] != null;
    } catch (e) {
      return false;
    }
  }
}
