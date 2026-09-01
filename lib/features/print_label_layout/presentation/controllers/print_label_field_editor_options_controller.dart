import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_label_field_editor_options_controller.g.dart';

@riverpod
class PrintLabelFieldEditorOptionsController
    extends _$PrintLabelFieldEditorOptionsController {
  @override
  FutureOr<BSFPrintLabelFieldEditorOptionsEntity> build(int layoutCode) async {
    ref.cache();
    final params = await ref.watch(ecRequestParamsProvider().future);
    return ref
        .read(ecPrintLabelLayoutRepositoryProvider)
        .getFieldEditorOptions(params, layoutCode);
  }
}
