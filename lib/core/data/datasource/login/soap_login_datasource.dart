import 'dart:convert';

import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:xml2json/xml2json.dart';

import '../../../domain/contracts/contracts.dart';
import '../../../../features/auth/data/models/user_model.dart';
import 'i_soap_login_datasource.dart';

class SoapLoginDatasource implements ISoapLoginDatasource {
  final SoapRequest soapAdapter;

  SoapLoginDatasource(this.soapAdapter);

  @override
  Future<UserModel> login({
    required String baseUrl,
    required String user,
    required String password,
  }) async {
    final response = await soapAdapter.post(
      parameters: {"user": user, "password": password},
      typeOfResponse: "UserCanLoginJsonResponse",
      soapAction: "UserCanLoginJson",
      serviceASMX: "CeltaSecurityService.asmx",
      typeOfResult: "UserCanLoginJsonResult",
      url: baseUrl.toLowerCase().removeWhiteSpaces(),
    );

    Map resultAsMap;
    try {
      resultAsMap = json.decode(response);
    } catch (e) {
      throw Exception(response);
    }

    final myTransformer = Xml2Json();
    myTransformer.parse(resultAsMap["Usuarios"][0]['CrossIdentity_Usuario']);
    String toParker = myTransformer.toParker();
    Map toParker2 = json.decode(toParker);

    Map<String, dynamic> userUpdated = resultAsMap["Usuarios"][0];
    userUpdated["CrossIdentity_Usuario"] = toParker2["string"];

    if (json.decode(response) is Map<String, dynamic>) {
      return UserModel.fromJson(userUpdated);
    } else {
      throw Exception(
        'Ocorreu um erro não esperado para efetuar o login'.hardcoded,
      );
    }
  }
}
