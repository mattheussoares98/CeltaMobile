import 'package:celta_inventario/features/adjust_cost/data/datasource/datasource.dart';
import 'package:celta_inventario/features/adjust_cost/data/model/model.dart';
import 'package:celta_inventario/features/adjust_cost/domain/entity/entity.dart';
import 'package:celta_inventario/features/adjust_cost/domain/repository/repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class EcAdjustCostDatasourceSpy extends Mock
    implements IEcAdjustCostDatasource {
  EcAdjustCostDatasourceSpy() {
    when(
      () => adjust(
        workingUrl: any(named: 'workingUrl'),
        user: any(named: 'user'),
        accessKey: any(named: 'accessKey'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async {});
  }
}

void main() {
  late IEcAdjustCostRepository sut;

  late String workingUrl;
  late String accessKey;
  late String user;
  late EcAdjustCostDatasourceSpy datasource;
  late AdjustCostParametersEntity parameters;

  void initSut() {
    sut = EcAdjustCostRepositoryImpl(datasource);
  }

  void initInjections() {
    datasource = EcAdjustCostDatasourceSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    accessKey = faker.guid.guid();
    user = faker.person.name();
    parameters = EntityFactory.makeAdjustCostParametersEntity();
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    registerFallbackValue(
      AdjustCostParametersModel.fromEntity(
        EntityFactory.makeAdjustCostParametersEntity(),
      ),
    );
  });
  test('should behave correctly on success', () async {
    await sut.adjust(
      workingUrl: workingUrl,
      user: user,
      accessKey: accessKey,
      parameters: parameters,
    );

    verify(
      () => datasource.adjust(
        workingUrl: workingUrl,
        user: user,
        accessKey: accessKey,
        parameters: AdjustCostParametersModel.fromEntity(parameters),
      ),
    ).called(1);

    verifyNoMoreInteractions(datasource);
  });
}
