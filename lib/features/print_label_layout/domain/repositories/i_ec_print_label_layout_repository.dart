import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

abstract class IEcPrintLabelLayoutRepository {
  Future<List<BSFPrintLabelLayoutSummaryEntity>> getSummaries(
    EcRequestParams params,
  );

  Future<BSFPrintLabelLayoutEntity> getDetails(
    EcRequestParams params,
    int code,
  );

  Future<BSFPrintLabelLayoutCreateOptionsEntity> getCreateOptions(
    EcRequestParams params,
  );

  Future<BSFPrintLabelLayoutEntity> create(
    EcRequestParams params,
    BSFPrintLabelLayoutEntity layout,
  );

  Future<BSFPrintLabelLayoutEntity> update(
    EcRequestParams params,
    BSFPrintLabelLayoutEntity layout,
  );

  Future<BSFPrintLabelFieldEditorOptionsEntity> getFieldEditorOptions(
    EcRequestParams params,
    int layoutCode,
  );
}
