import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/data/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockEcPrintLabelLayoutDatasource extends Mock
    implements IEcPrintLabelLayoutDatasource {}

void main() {
  late IEcPrintLabelLayoutRepository sut;
  late MockEcPrintLabelLayoutDatasource datasource;
  late EcRequestParams params;
  late BSFPrintLabelLayoutSummaryEntity summaryEntity;
  late BSFPrintLabelLayoutSummaryModel summaryModel;
  late BSFPrintLabelLayoutEntity layoutEntity;
  late BSFPrintLabelLayoutModel layoutModel;

  setUp(() {
    datasource = MockEcPrintLabelLayoutDatasource();
    sut = EcPrintLabelLayoutRepositoryImpl(datasource);
    params = EntityFactory.makeEcRequestParams();
    summaryEntity = EntityFactory.makeBSFPrintLabelLayoutSummaryEntity();
    summaryModel = BSFPrintLabelLayoutSummaryModel.fromEntity(summaryEntity);
    layoutEntity = EntityFactory.makeBSFPrintLabelLayoutEntity();
    layoutModel = BSFPrintLabelLayoutModel.fromEntity(layoutEntity);
  });

  group('getSummaries', () {
    test('should return entities from datasource models', () async {
      when(
        () => datasource.getSummaries(params),
      ).thenAnswer((_) async => [summaryModel]);

      final result = await sut.getSummaries(params);

      expect(result, [summaryEntity]);
      verify(() => datasource.getSummaries(params)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to get label layout summaries');
      when(() => datasource.getSummaries(params)).thenThrow(exception);

      final call = sut.getSummaries(params);

      await expectLater(call, throwsA(same(exception)));
      verify(() => datasource.getSummaries(params)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('getDetails', () {
    test('should return an entity from the datasource model', () async {
      when(
        () => datasource.getDetails(params, layoutEntity.code),
      ).thenAnswer((_) async => layoutModel);

      final result = await sut.getDetails(params, layoutEntity.code);

      expect(result, layoutEntity);
      verify(() => datasource.getDetails(params, layoutEntity.code)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to get label layout details');
      when(
        () => datasource.getDetails(params, layoutEntity.code),
      ).thenThrow(exception);

      final call = sut.getDetails(params, layoutEntity.code);

      await expectLater(call, throwsA(same(exception)));
      verify(() => datasource.getDetails(params, layoutEntity.code)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });
}
