import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/providers/products/products.dart';
import 'package:celta_inventario/features/enterprises/presentation/controllers/controllers.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/presentation/controllers/app_usage/app_usage.dart';
import 'package:celta_inventario/core/presentation/controllers/user_session/user_session.dart';

part 'shallow_products_state_controller.g.dart';

@riverpod
class ShallowProductsStateController extends _$ShallowProductsStateController {
  // PERFORMANCE: Storing the active token allows the next 'load' call
  // to kill the previous one before it wastes more CPU/Data.
  CancelToken? _activeToken;
  String? _lastEmptySearch;

  @override
  FutureOr<List<ProductEntity>?> build() async {
    ref.onDispose(() => _activeToken?.cancel());
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
    return null;
  }

  Future<void> load(String name) async {
    if (_activeToken?.name.trim() == name.trim()) {
      return;
    } else if (int.tryParse(name) != null ||
        name.removeWhiteSpaces().length < 3) {
      //should not search if is a number
      return;
    } else if (_lastEmptySearch != null && name.startsWith(_lastEmptySearch!)) {
      // PERFORMANCE: Short-circuit check. If 'name' starts with a previously
      // recorded empty search string, we return immediately.
      return;
    } else {
      _lastEmptySearch = null;
    }

    _activeToken?.cancel();

    //new token for this call
    final token = CancelToken(name);
    _activeToken = token;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      ref
          .read(appUsageStateControllerProvider.notifier)
          .addUsage(UsageType.shallowSearchProduct);

      final userSession = await ref.watch(validatedUserSessionProvider.future);
      final workingUrl = userSession!.enterprise!.workingUrl!;
      final accessKey = userSession.user.AccessKey!;
      final user = userSession.user.name!;

      final enterpriseId = ref.read(
        selectedEnterpriseStateControllerProvider.select((s) => s!.Code!),
      );

      final products = await ref
          .read(ecGetShallowProductsRepositoryProvider)
          .get(
            workingUrl: workingUrl,
            user: user,
            accessKey: accessKey,
            name: name,
            enterpriseId: enterpriseId,
            cancelToken: token,
          );

      // PERFORMANCE: If the API returns nothing, we "lock" this name
      // as the base for the negative cache.
      if (products.isEmpty) {
        _lastEmptySearch = name;
      } else {
        _lastEmptySearch = null;
      }

      return List<ProductEntity>.from(products);
    });
  }
}
