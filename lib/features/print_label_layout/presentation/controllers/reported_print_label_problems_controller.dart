import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reported_print_label_problems_controller.g.dart';

@riverpod
class ReportedPrintLabelProblemsController
    extends _$ReportedPrintLabelProblemsController {
  @override
  FutureOr<List<ReportedPrintLabelProblemEntity>> build() async {
    ref.cache();
    return ref.read(printLabelProblemReportRepositoryProvider).getAll();
  }
}
