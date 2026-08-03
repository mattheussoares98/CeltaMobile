import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/synchronizer/presentation/controllers/controllers.dart';
import 'package:celta_inventario/features/synchronizer/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'link_product_without_register_controller.g.dart';

@riverpod
class LinkProductWithoutRegisterController
    extends _$LinkProductWithoutRegisterController {
  @override
  FutureOr<void> build() {}

  void link({
    required String errorKey,
    required int productNotFoundCode,
    required int productCode,
    required int productPackingCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(ecSynchronizerRepositoryProvider);
      final ecParams = await ref.read(ecRequestParamsProvider().future);

      await repository.linkSaleRequestProductNotFound(
        ecParams,
        productNotFoundCode: productNotFoundCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
      );

      await ref
          .read(synchronizerDetailsStateControllerProvider(errorKey).notifier)
          .loadSilently();
    });
  }
}
