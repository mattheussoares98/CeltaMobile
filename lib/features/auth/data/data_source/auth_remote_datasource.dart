import 'dart:convert';

import 'package:celta_intelligence/localization/string_hardcoded.dart';
import 'package:xml2json/xml2json.dart';

import '../../../../core/domain/repositories/repositories.dart';
import '../models/user_model.dart';
import 'i_auth_remote_datasource.dart';

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final SoapRequest soapAdapter;

  AuthRemoteDatasource(this.soapAdapter);

  @override
  Future<UserModel> login({
    required String url,
    required String user,
    required String password,
  }) async {
    final response = await soapAdapter.post(
      parameters: {"user": user, "password": password},
      typeOfResponse: "UserCanLoginJsonResponse",
      soapAction: "UserCanLoginJson",
      serviceASMX: "CeltaSecurityService.asmx",
      typeOfResult: "UserCanLoginJsonResult",
      url: url,
    );

    Map resultAsMap = json.decode(response);

    final myTransformer = Xml2Json();
    myTransformer.parse(resultAsMap["Usuarios"][0]['CrossIdentity_Usuario']);
    String toParker = myTransformer.toParker();
    Map toParker2 = json.decode(toParker);

    Map<String, dynamic> userUpdated = resultAsMap["Usuarios"][0];
    userUpdated["CrossIdentity_Usuario"] = toParker2["string"];

    if (response is Map<String, dynamic>) {
      return UserModel.fromJson(userUpdated);
    } else {
      throw Exception(
        'Login failed: Unexpected response format from API'.hardcoded,
      );
    }
  }
}
