import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/mocks.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late IEcPrintLabelLayoutDatasource sut;
  late MockHttpClient httpClient;
  late EcRequestParams params;
  late BSFPrintLabelLayoutSummaryModel summaryModel;
  late BSFPrintLabelLayoutModel layoutModel;
  late BSFPrintLabelFieldEditorOptionsModel fieldEditorOptionsModel;

  setUp(() {
    httpClient = MockHttpClient();
    sut = EcPrintLabelLayoutDatasource(httpClient);
    params = EntityFactory.makeEcRequestParams();
    summaryModel = BSFPrintLabelLayoutSummaryModel.fromEntity(
      EntityFactory.makeBSFPrintLabelLayoutSummaryEntity(),
    );
    layoutModel = BSFPrintLabelLayoutModel.fromEntity(
      EntityFactory.makeBSFPrintLabelLayoutEntity(),
    );
    fieldEditorOptionsModel = BSFPrintLabelFieldEditorOptionsModel.fromEntity(
      EntityFactory.makeBSFPrintLabelFieldEditorOptionsEntity(),
    );
  });

  test('should get and map label layout summaries', () async {
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/Summary',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenAnswer((_) async => [summaryModel.toJson()]);

    final result = await sut.getSummaries(params);

    expect(result, [summaryModel]);
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/Summary',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should return an empty list when there are no summaries', () async {
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/Summary',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenAnswer((_) async => []);

    final result = await sut.getSummaries(params);

    expect(result, isEmpty);
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/Summary',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should propagate summary request errors', () async {
    final exception = Exception('Failed to get label layout summaries');
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/Summary',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenThrow(exception);

    final call = sut.getSummaries(params);

    await expectLater(call, throwsA(same(exception)));
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/Summary',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should get and map complete label layout details', () async {
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenAnswer((_) async => layoutModel.toJson());

    final result = await sut.getDetails(params, layoutModel.code);

    expect(result, layoutModel);
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should propagate detail request errors', () async {
    final exception = Exception('Failed to get label layout details');
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenThrow(exception);

    final call = sut.getDetails(params, layoutModel.code);

    await expectLater(call, throwsA(same(exception)));
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should get all field editor options in one request', () async {
    when(
      () => httpClient.request(
        url:
            '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}/FieldEditorOptions',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenAnswer((_) async => fieldEditorOptionsModel.toJson());

    final result = await sut.getFieldEditorOptions(params, layoutModel.code);

    expect(result, fieldEditorOptionsModel);
    verify(
      () => httpClient.request(
        url:
            '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}/FieldEditorOptions',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should propagate field editor options request errors', () async {
    final exception = Exception('Failed to get field editor options');
    when(
      () => httpClient.request(
        url:
            '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}/FieldEditorOptions',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).thenThrow(exception);

    final call = sut.getFieldEditorOptions(params, layoutModel.code);

    await expectLater(call, throwsA(same(exception)));
    verify(
      () => httpClient.request(
        url:
            '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}/FieldEditorOptions',
        method: 'get',
        headers: params.toHeaders(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should update and map the complete label layout', () async {
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}',
        method: 'put',
        headers: params.toHeaders(),
        body: layoutModel.toJson(),
      ),
    ).thenAnswer((_) async => layoutModel.toJson());

    final result = await sut.update(params, layoutModel);

    expect(result, layoutModel);
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}',
        method: 'put',
        headers: params.toHeaders(),
        body: layoutModel.toJson(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });

  test('should propagate update request errors', () async {
    final exception = Exception('Failed to update label layout');
    when(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}',
        method: 'put',
        headers: params.toHeaders(),
        body: layoutModel.toJson(),
      ),
    ).thenAnswer((_) async => throw exception);

    await expectLater(
      sut.update(params, layoutModel),
      throwsA(same(exception)),
    );
    verify(
      () => httpClient.request(
        url: '${params.workingUrl}/api/PrintLabelLayouts/${layoutModel.code}',
        method: 'put',
        headers: params.toHeaders(),
        body: layoutModel.toJson(),
      ),
    ).called(1);
    verifyNoMoreInteractions(httpClient);
  });
}
