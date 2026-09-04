import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';

abstract class IEcPrintLabelLayoutDatasource {
  Future<List<BSFPrintLabelLayoutSummaryModel>> getSummaries(
    EcRequestParams params,
  );

  Future<BSFPrintLabelLayoutModel> getDetails(EcRequestParams params, int code);

  Future<BSFPrintLabelLayoutCreateOptionsModel> getCreateOptions(
    EcRequestParams params,
  );

  Future<BSFPrintLabelLayoutModel> create(
    EcRequestParams params,
    BSFPrintLabelLayoutModel layout,
  );

  Future<BSFPrintLabelLayoutModel> update(
    EcRequestParams params,
    BSFPrintLabelLayoutModel layout,
  );

  Future<BSFPrintLabelFieldEditorOptionsModel> getFieldEditorOptions(
    EcRequestParams params,
    int layoutCode,
  );

  Future<BSFPrintLabelFieldEditorOptionsModel> getDraftFieldEditorOptions(
    EcRequestParams params,
    BSFPrintLabelLayoutModel draft,
  );
}
