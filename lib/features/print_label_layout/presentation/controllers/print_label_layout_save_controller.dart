import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/exceptions/exceptions.dart';
import 'package:celta_inventario/features/print_label_layout/domain/validators/validators.dart';
import 'package:celta_inventario/features/print_label_layout/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/print_label_layout/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_label_layout_save_controller.g.dart';

@riverpod
class PrintLabelLayoutSaveController extends _$PrintLabelLayoutSaveController {
  @override
  FutureOr<void> build(int layoutCode) {}

  Future<void> save() async {
    if (state.isLoading) return;

    final detailsProvider = printLabelLayoutDetailsControllerProvider(
      layoutCode,
    );
    final draft = ref.read(detailsProvider).value;
    if (draft == null) return;

    final validationErrors = PrintLabelLayoutSaveValidator.validate(draft);
    if (validationErrors.isNotEmpty) {
      state = AsyncError(
        AppException(validationErrors.join('\n')),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final params = await ref.read(ecRequestParamsProvider().future);
      final repository = ref.read(ecPrintLabelLayoutRepositoryProvider);
      final saved = draft.code == 0
          ? await repository.create(params, draft)
          : await repository.update(params, draft);
      //TODO add appUsage
      ref.read(detailsProvider.notifier).replaceWithSavedLayout(saved);
    });
  }
}
