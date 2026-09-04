import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';

class EcPrintLabelLayoutDatasource implements IEcPrintLabelLayoutDatasource {
  final HttpClient httpClient;

  const EcPrintLabelLayoutDatasource(this.httpClient);

  @override
  Future<List<BSFPrintLabelLayoutSummaryModel>> getSummaries(
    EcRequestParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/PrintLabelLayouts/Summary',
      method: 'get',
      headers: params.toHeaders(),
    );

    return (response as List)
        .map((json) => BSFPrintLabelLayoutSummaryModel.fromJson(json as Map))
        .toList();
  }

  @override
  Future<BSFPrintLabelLayoutModel> getDetails(
    EcRequestParams params,
    int code,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/PrintLabelLayouts/$code',
      method: 'get',
      headers: params.toHeaders(),
    );

    return BSFPrintLabelLayoutModel.fromJson(response as Map);
  }

  @override
  Future<BSFPrintLabelLayoutCreateOptionsModel> getCreateOptions(
    EcRequestParams params,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/PrintLabelLayouts/CreateOptions',
      method: 'get',
      headers: params.toHeaders(),
    );

    return BSFPrintLabelLayoutCreateOptionsModel.fromJson(response as Map);
  }

  @override
  Future<BSFPrintLabelLayoutModel> create(
    EcRequestParams params,
    BSFPrintLabelLayoutModel layout,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/PrintLabelLayouts',
      method: 'post',
      headers: params.toHeaders(),
      body: layout.toJson(),
    );

    return BSFPrintLabelLayoutModel.fromJson(response as Map);
  }

  @override
  Future<BSFPrintLabelLayoutModel> update(
    EcRequestParams params,
    BSFPrintLabelLayoutModel layout,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/PrintLabelLayouts/${layout.code}',
      method: 'put',
      headers: params.toHeaders(),
      body: layout.toJson(),
    );

    return BSFPrintLabelLayoutModel.fromJson(response as Map);
  }

  @override
  Future<BSFPrintLabelFieldEditorOptionsModel> getFieldEditorOptions(
    EcRequestParams params,
    int layoutCode,
  ) async {
    final response = await httpClient.request(
      url:
          '${params.workingUrl}/api/PrintLabelLayouts/$layoutCode/FieldEditorOptions',
      method: 'get',
      headers: params.toHeaders(),
    );

    return BSFPrintLabelFieldEditorOptionsModel.fromJson(response as Map);
  }

  @override
  Future<BSFPrintLabelFieldEditorOptionsModel> getDraftFieldEditorOptions(
    EcRequestParams params,
    BSFPrintLabelLayoutModel draft,
  ) async {
    final response = await httpClient.request(
      url: '${params.workingUrl}/api/PrintLabelLayouts/FieldEditorOptions',
      method: 'post',
      headers: params.toHeaders(),
      body: draft.toJson(),
    );

    return BSFPrintLabelFieldEditorOptionsModel.fromJson(response as Map);
  }
}
