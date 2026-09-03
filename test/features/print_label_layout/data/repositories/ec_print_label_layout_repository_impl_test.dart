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
  late BSFPrintLabelFieldEditorOptionsEntity fieldEditorOptionsEntity;
  late BSFPrintLabelFieldEditorOptionsModel fieldEditorOptionsModel;

  setUp(() {
    datasource = MockEcPrintLabelLayoutDatasource();
    sut = EcPrintLabelLayoutRepositoryImpl(datasource);
    params = EntityFactory.makeEcRequestParams();
    summaryEntity = EntityFactory.makeBSFPrintLabelLayoutSummaryEntity();
    summaryModel = BSFPrintLabelLayoutSummaryModel.fromEntity(summaryEntity);
    layoutEntity = EntityFactory.makeBSFPrintLabelLayoutEntity();
    layoutModel = BSFPrintLabelLayoutModel.fromEntity(layoutEntity);
    fieldEditorOptionsEntity =
        EntityFactory.makeBSFPrintLabelFieldEditorOptionsEntity();
    fieldEditorOptionsModel = BSFPrintLabelFieldEditorOptionsModel.fromEntity(
      fieldEditorOptionsEntity,
    );
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

  group('getFieldEditorOptions', () {
    test('should return an entity from the datasource model', () async {
      when(
        () => datasource.getFieldEditorOptions(params, layoutEntity.code),
      ).thenAnswer((_) async => fieldEditorOptionsModel);

      final result = await sut.getFieldEditorOptions(params, layoutEntity.code);

      expect(result, fieldEditorOptionsEntity);
      verify(
        () => datasource.getFieldEditorOptions(params, layoutEntity.code),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to get field editor options');
      when(
        () => datasource.getFieldEditorOptions(params, layoutEntity.code),
      ).thenThrow(exception);

      final call = sut.getFieldEditorOptions(params, layoutEntity.code);

      await expectLater(call, throwsA(same(exception)));
      verify(
        () => datasource.getFieldEditorOptions(params, layoutEntity.code),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('update', () {
    test('should return the server-updated entity', () async {
      final updatedEntity = layoutEntity.copyWith(name: 'Updated');
      final updatedModel = BSFPrintLabelLayoutModel.fromEntity(updatedEntity);
      when(
        () => datasource.update(params, layoutModel),
      ).thenAnswer((_) async => updatedModel);

      final result = await sut.update(params, layoutEntity);

      expect(result, updatedEntity);
      verify(() => datasource.update(params, layoutModel)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('should propagate datasource errors', () async {
      final exception = Exception('Failed to update label layout');
      when(() => datasource.update(params, layoutModel)).thenThrow(exception);

      await expectLater(
        sut.update(params, layoutEntity),
        throwsA(same(exception)),
      );
      verify(() => datasource.update(params, layoutModel)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });
}
