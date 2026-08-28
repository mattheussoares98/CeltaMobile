import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_label_layout_summaries_controller.g.dart';

@riverpod
class PrintLabelLayoutSummariesController
    extends _$PrintLabelLayoutSummariesController {
  @override
  FutureOr<List<BSFPrintLabelLayoutSummaryEntity>> build() async {
    final params = await ref.watch(ecRequestParamsProvider().future);
    return ref.read(ecPrintLabelLayoutRepositoryProvider).getSummaries(params);
  }
}
