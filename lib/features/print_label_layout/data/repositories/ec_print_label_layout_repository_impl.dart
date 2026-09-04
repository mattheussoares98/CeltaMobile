import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/models/models.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';

class EcPrintLabelLayoutRepositoryImpl
    implements IEcPrintLabelLayoutRepository {
  final IEcPrintLabelLayoutDatasource datasource;

  const EcPrintLabelLayoutRepositoryImpl(this.datasource);

  @override
  Future<List<BSFPrintLabelLayoutSummaryEntity>> getSummaries(
    EcRequestParams params,
  ) async {
    final models = await datasource.getSummaries(params);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<BSFPrintLabelLayoutEntity> getDetails(
    EcRequestParams params,
    int code,
  ) async {
    final model = await datasource.getDetails(params, code);
    return model.toEntity();
  }

  @override
  Future<BSFPrintLabelLayoutEntity> create(
    EcRequestParams params,
    BSFPrintLabelLayoutEntity layout,
  ) async {
    final model = await datasource.create(
      params,
      BSFPrintLabelLayoutModel.fromEntity(layout),
    );
    return model.toEntity();
  }

  @override
  Future<BSFPrintLabelLayoutEntity> update(
    EcRequestParams params,
    BSFPrintLabelLayoutEntity layout,
  ) async {
    final model = await datasource.update(
      params,
      BSFPrintLabelLayoutModel.fromEntity(layout),
    );
    return model.toEntity();
  }

  @override
  Future<BSFPrintLabelFieldEditorOptionsEntity> getFieldEditorOptions(
    EcRequestParams params,
    int layoutCode,
  ) async {
    final model = await datasource.getFieldEditorOptions(params, layoutCode);
    return model.toEntity();
  }
}
