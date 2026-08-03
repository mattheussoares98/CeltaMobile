import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/products_register/providers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_state_controller.g.dart';

@riverpod
class ProductStateController extends _$ProductStateController {
  @override
  FutureOr<dynamic> build({
    required int enterpriseCode,
    required int productCode,
  }) async {
    ref.cache();

    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    return await ref
        .read(ecProductRepositoryProvider)
        .get(
          ecParams,
          productCode: productCode,
          enterpriseCode: enterpriseCode,
        );
  }
}
