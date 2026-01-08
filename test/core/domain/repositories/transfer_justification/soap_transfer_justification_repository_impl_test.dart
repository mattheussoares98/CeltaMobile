import 'package:celta_intelligence/core/data/models/models.dart';
import 'package:celta_intelligence/core/domain/entities/entities.dart';
import 'package:celta_intelligence/core/domain/repositories/transfer_justification/transfer_justification.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late ISoapTransferJustificationRepository sut;

  late SoapTransferJustificationDatasourceSpy
  soapTransferJustificationDatasource;

  late List<TransferJustificationEntity> transferJustificationEntities;
  late String urlInUse;
  late String crossIdentity;
  late TransferJustificationType type;

  void initSut() {
    sut = SoapTransferJustificationRepositoryImpl(
      soapTransferJustificationDatasource,
    );
  }

  void initInjections() {
    soapTransferJustificationDatasource =
        SoapTransferJustificationDatasourceSpy();
  }

  void mockSuccess() {
    soapTransferJustificationDatasource.mockLoad(
      transferJustificationEntities
          .map((e) => TransferJustificationModel.fromEntity(e))
          .toList(),
    );
  }

  void initEntities() {
    transferJustificationEntities = [
      EntityFactory.makeTransferJustificationEntity(),
      EntityFactory.makeTransferJustificationEntity(),
      EntityFactory.makeTransferJustificationEntity(),
    ];
    urlInUse = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    type =
        TransferJustificationType.values[faker.randomGenerator.integer(
          TransferJustificationType.values.length,
        )];
  }

  setUp(() {
    initEntities();
    initInjections();
    initSut();
    mockSuccess();
  });

  setUpAll(() {
    for (var value in TransferJustificationType.values) {
      registerFallbackValue(value);
    }
  });

  test("Should behave correctly on load", () async {
    final response = await sut.load(
      urlInUse: urlInUse,
      crossIdentity: crossIdentity,
      type: type,
    );

    expect(response, transferJustificationEntities);

    verify(
      () => soapTransferJustificationDatasource.load(
        urlInUse: urlInUse,
        crossIdentity: crossIdentity,
        type: type,
      ),
    ).called(1);
  });
}
