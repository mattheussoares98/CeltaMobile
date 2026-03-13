import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/domain/entities/entities.dart';
import '../../../../../core/providers/products/products.dart';
import '../../../../features/enterprises/presentation/controllers/controllers.dart';
import '../../../../utils/utils.dart';
import '../../../domain/contracts/contracts.dart';
import '../app_usage/app_usage.dart';
import '../user_session/user_session.dart';

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
    if (int.tryParse(name) != null || name.removeWhiteSpaces().length < 3) {
      //should not search if is a number
      return;
    }

    // PERFORMANCE: Short-circuit check. If 'name' starts with a previously
    // recorded empty search string, we return immediately.
    if (_lastEmptySearch != null && name.startsWith(_lastEmptySearch!)) {
      return;
    } else {
      _lastEmptySearch = null;
    }

    //cancel the previous call
    _activeToken?.cancel();

    //new token for this call
    final token = CancelToken();
    _activeToken = token;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      debugPrint('loading');
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
          .read(ecommerceGetShallowProductsRepositoryProvider)
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
