import 'dart:convert';

import 'package:celta_inventario/core/data/datasource/transfer_justification/transfer_justification.dart';
import 'package:celta_inventario/core/data/models/models.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

void main() {
  late SoapTransferJustificationDatasource sut;

  late SoapRequestSpy soapAdapter;

  late String workingUrl;
  late String crossIdentity;
  late List<TransferJustificationEntity> transferJustificationEntties;
  late TransferJustificationType transferJustificationType;

  void initSut() {
    sut = SoapTransferJustificationDatasource(soapAdapter);
  }

  void initInjections() {
    soapAdapter = SoapRequestSpy();
  }

  void mockSuccess() {}

  void initEntities() {
    workingUrl = faker.internet.httpUrl();
    crossIdentity = faker.guid.guid();
    transferJustificationEntties = [
      EntityFactory.makeTransferJustificationEntity(),
      EntityFactory.makeTransferJustificationEntity(),
      EntityFactory.makeTransferJustificationEntity(),
    ];
    transferJustificationType =
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
    for (var routine in BsRoutine.values) {
      registerFallbackValue(routine);
    }

    for (var resource in BsResource.values) {
      registerFallbackValue(resource);
    }
  });

  group('Can access resource', () {
    test('should behave correctly', () async {
      soapAdapter.mockPost(
        json.encode(
          transferJustificationEntties
              .map((e) => TransferJustificationModel.fromEntity(e).toJson())
              .toList(),
        ),
      );

      final result = await sut.load(
        workingUrl: workingUrl,
        crossIdentity: crossIdentity,
        type: transferJustificationType,
      );

      expect(
        result,
        transferJustificationEntties
            .map((e) => TransferJustificationModel.fromEntity(e))
            .toList(),
      );

      verify(
        () => soapAdapter.post(
          url: workingUrl,
          typeOfResponse: "GetJustificationsResponse",
          typeOfResult: "GetJustificationsResult",
          soapAction: "GetJustifications",
          serviceASMX: "CeltaProductService.asmx",
          parameters: {
            "crossIdentity": crossIdentity,
            'simpleSearchValue': 'undefined',
            "justificationTransferType": transferJustificationType.code,
          },
        ),
      ).called(1);
    });
  });
}
