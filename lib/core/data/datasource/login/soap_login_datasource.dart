import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/core/domain/errors/errors.dart';
import 'dart:convert';

import 'package:celta_inventario/utils/utils.dart';
import 'package:xml2json/xml2json.dart';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/features/auth/data/models/user_model.dart';
import 'package:celta_inventario/core/data/datasource/login/i_soap_login_datasource.dart';

class SoapLoginDatasource implements ISoapLoginDatasource {
  final SoapRequest soapAdapter;

  SoapLoginDatasource(this.soapAdapter);

  @override
  Future<UserModel> login({
    required String workingUrl,
    required String user,
    required String password,
  }) async {
    final response = await soapAdapter.post(
      parameters: {"user": user.trim(), "password": password},
      typeOfResponse: "UserCanLoginJsonResponse",
      soapAction: "UserCanLoginJson",
      serviceASMX: "CeltaSecurityService.asmx",
      typeOfResult: "UserCanLoginJsonResult",
      url: workingUrl.toLowerCase().removeWhiteSpaces(),
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
      throw AppException.localized(CoreFailure.unexpectedLoginError);
    }
  }
}
