import 'package:celta_intelligence/core/data/datasource/datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapLoginDataSource sut;

  late MockSoapAdapter soapAdapter;

  late String url;
  late String user;
  late String password;

  void initSut() {
    sut = SoapLoginDataSource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = MockSoapAdapter();
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
    //TODO fix this test after get an example of the response
    test('should call soap adapter with correct values', () async {
      soapAdapter.mockGet("");

      await sut.login(baseUrl: url, user: user, password: password);

      verify(
        () => soapAdapter.post(
          url: url,
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
