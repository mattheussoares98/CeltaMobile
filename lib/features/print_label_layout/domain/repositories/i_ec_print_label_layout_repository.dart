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
}
