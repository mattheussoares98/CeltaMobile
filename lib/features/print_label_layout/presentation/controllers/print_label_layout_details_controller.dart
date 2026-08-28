import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/print_label_layout/domain/entities/entities.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:celta_inventario/utils/extensions/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_label_layout_details_controller.g.dart';

@riverpod
class PrintLabelLayoutDetailsController
    extends _$PrintLabelLayoutDetailsController {
  @override
  FutureOr<BSFPrintLabelLayoutEntity> build(int code) async {
    ref.cache();
    final params = await ref.watch(ecRequestParamsProvider().future);
    return ref
        .read(ecPrintLabelLayoutRepositoryProvider)
        .getDetails(params, code);
  }
}
