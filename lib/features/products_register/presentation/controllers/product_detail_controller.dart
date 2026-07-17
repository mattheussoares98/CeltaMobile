import 'dart:async';

import 'package:celta_inventario/core/providers/ec_request_params/ec_request_params.dart';
import 'package:celta_inventario/features/products_register/domain/entities/entities.dart';
import 'package:celta_inventario/features/products_register/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_detail_controller.g.dart';

@riverpod
class ProductDetailController extends _$ProductDetailController {
  @override
  FutureOr<BsfProductEntity> build({
    required int enterpriseCode,
    required int productCode,
  }) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), link.close);
    });
    ref.onResume(() => timer?.cancel());
    ref.onDispose(() => timer?.cancel());

    final ecParams = await ref.watch(ecRequestParamsProvider().future);

    return ref
        .read(ecProductRepositoryProvider)
        .get(
          ecParams,
          productCode: productCode,
          enterpriseCode: enterpriseCode,
        );
  }

  List<BsfProductPropertyEntity> search(String query) {
    final entity = state.value;
    if (entity == null) return [];
    if (query.trim().isEmpty) return entity.toSearchIndex();

    final lowerQuery = query.toLowerCase();
    return entity
        .toSearchIndex()
        .where((p) => p.labelPt.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
