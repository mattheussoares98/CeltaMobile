import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';
import 'package:celta_inventario/features/inventory/domain/entities/entities.dart';
import 'package:celta_inventario/features/inventory/providers.dart';

part 'inventory_state_controller.g.dart';

@riverpod
class InventoryStateController extends _$InventoryStateController {
  @override
  FutureOr<InventoryEntity?> build(int enterpriseCode) async {
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
        .read(soapLoadInventoryRepositoryProvider)
        .load(
          workingUrl: validatedUser!.enterprise!.workingUrl!,
          crossIdentity: validatedUser.user.CrossIdentity_Usuario!,
          enterpriseCode: enterpriseCode,
        );
  }
}
