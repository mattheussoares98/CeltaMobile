import 'package:celta_inventario/features/expedition_conference/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/expedition_conference/data/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapConfirmConferenceRepository sut;

  late SoapConfirmConferenceDatasourceSpy datasource;

  late String workingUrl;
  late String crossIdentity;
  late int expeditionControlCode;
  late int stepCode;

  void initSut() {
    sut = SoapConfirmConferenceRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = SoapConfirmConferenceDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpsUrl();
    crossIdentity = faker.guid.guid();
    expeditionControlCode = faker.randomGenerator.integer(1000);
    stepCode = faker.randomGenerator.integer(1000);
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  test('should behave correctly on success', () async {
    await sut.confirm(
      workingUrl: workingUrl,
      crossIdentity: crossIdentity,
      expeditionControlCode: expeditionControlCode,
      stepCode: stepCode,
    );

    verify(
      () => datasource.confirm(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        expeditionControlCode: expeditionControlCode,
        stepCode: stepCode,
      ),
    );
    verifyNoMoreInteractions(datasource);
  });
}
