import 'dart:async';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/products_register/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_state_controller.g.dart';

@riverpod
class ProductStateController extends _$ProductStateController {
  @override
  FutureOr<dynamic> build({
    required int enterpriseCode,
    required int productCode,
  }) async {
    Timer? timer;
    final link = ref.keepAlive();
    ref.onCancel(() {
      timer = Timer(const Duration(seconds: 20), () {
        link.close();
      });
    });
    ref.onResume(() {
      timer?.cancel();
    });
    ref.onDispose(() {
      timer?.cancel();
    });

    final validatedUser = await ref.watch(validatedUserSessionProvider.future);

    return await ref
        .read(ecProductRepositoryProvider)
        .get(
          EcRequestParams(
            workingUrl: validatedUser!.enterprise!.workingUrl!,
            user: validatedUser.user.name!,
            accessKey: validatedUser.user.AccessKey!,
          ),
          productCode: productCode,
          enterpriseCode: enterpriseCode,
        );
  }
}
