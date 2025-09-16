import 'package:celta_intelligence/core/data/datasource/datasource.dart';
import 'package:celta_intelligence/utils/utils.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapLoginDataSource sut;

  late SoapRequestSpy soapAdapter;

  late String url;
  late String user;
  late String password;

  void initSut() {
    sut = SoapLoginDataSource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  // void mockSuccess() {}

  void initEntities() {
    url = faker.internet.httpsUrl();
    user = faker.internet.userName();
    password = faker.internet.password();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    // mockSuccess();
  });

  group('login', () {
    test('should call soap adapter with correct values', () async {
      soapAdapter.mockPost(
        '''{"Usuarios":[{"CodigoInterno_Usuario":31,"Identificacao_Usuario":"Soares Celta","CrossIdentity_Usuario":"<?xml version=1.0 encoding='utf-16'?><string>¬EncryptedDataInfo£¬EncryptedData£YK+VEwjm03v47TUiBB7vjJdmCdOU3aadRyQ9Jc0KfV5plGTM/rjzwShKAGPZ83WO6gBLnUN9C/Vka6mnAJs8yh9COYrYmLUjlpctW9QRR1qkw3PIK/kL+Jq8Cg9Ar+SYF0MHWAQss4AYH0yieU3BsKGGW34KKCUnR16yZWpARYmRaHCE0TbrCDUK/P61su/85h8avmGdvh5o6S5qdc6YzM2PDDI+OeySbCQ5BblzKFM/GdwlWw0AtrBqQnSLcBw505XH8+CpUet/EbIL/eS6UkOaLZGHpLa9Vh/uNTrtzI0zq7u4s6Z70u9ufb8+WcchEPrX1s7q+Qd29hK4eWRKo76IyXzEAv1BjYvgBXakq4HfRYoKd/i9Kdc5sOagRK9rgaDiq3DSIklq9iLEoJDd6+9UhXQP034x¬/EncryptedData£¬EncryptedIV£KO7JylNzQlRqqL58eU7VChZeVCDAuXkVzsMXXqT84YN1xWgLbGshAnPIEwn5d5bySHD7ye3CB3Mcq3VwGsNmE7nJLDPKMBxf5CGFHmvrpjObjRf+BV3mH1g1jMfkgPTBQJckd8oZw74H+NYWRNJhFDxHqSbSxhD4ETpqfsVSWY0=¬/EncryptedIV£¬EncryptedKey£HeX8AVjfawp14RtTYMnfcnLduR8BNRVVlAcqH/qTERrSxyzOcdj2v2YpF7PfOlfXzUMyjqIL1EnKUZ/oSX9vkH0rKhkzK0wH6OewhHzFEkqtcEyFWtbCFHsC5LEZksZHubH1qBeEECFRDg/4nJWs1XgI02qHCG2ETZTOK/yOsys=¬/EncryptedKey£¬/EncryptedDataInfo£</string>","AccessKey":"D8978fOrRRL4/RNV0ZumGuvBwuNzceEX"}]}''',
      );

      await sut.login(
        baseUrl: " $url ".toUpperCase(),
        user: user,
        password: password,
      );

      verify(
        () => soapAdapter.post(
          url: url.toLowerCase().removeWhiteSpaces(),
          parameters: {"user": user, "password": password},
          typeOfResponse: "UserCanLoginJsonResponse",
          soapAction: "UserCanLoginJson",
          serviceASMX: "CeltaSecurityService.asmx",
          typeOfResult: "UserCanLoginJsonResult",
        ),
      ).called(1);
    });
  });
}
