import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';

abstract class IPrintLabelProblemReportEnvironmentService {
  Future<PrintLabelProblemReportEnvironmentEntity> load();
}
