import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/providers/products/products.dart';
import '../../../../../core/domain/entities/entities.dart';
import '../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../user_session/user_session.dart';

part 'shallow_products_state_controller.g.dart';

@riverpod
class ShallowProductsStateController extends _$ShallowProductsStateController {
  @override
  Future<List<ProductEntity>> build() async {
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

    return [];
  }

  Future<void> load(String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userSession = await ref.watch(validatedUserSessionProvider.future);
      final workingUrl = userSession!.enterprise!.workingUrl!;
      final accessKey = userSession.user.AccessKey!;
      final user = userSession.user.name!;

      final enterpriseId = ref.read(
        selectedEnterpriseStateControllerProvider.select((s) => s!.Code!),
      );

      final products = await ref
          .read(ecommerceGetShallowProductsRepositoryProvider)
          .get(
            workingUrl: workingUrl,
            user: user,
            accessKey: accessKey,
            name: name,
            enterpriseId: enterpriseId,
          );

      return List<ProductEntity>.from(products);
    });
  }
}
