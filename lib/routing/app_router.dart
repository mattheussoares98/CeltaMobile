import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/controllers/controllers.dart';
import '../features/enterprise_manager/presentation/controllers/controllers.dart';
import 'not_found_page.dart';
import 'routes/routes.dart';

part 'app_router.g.dart';

enum AppRoute {
  auth,
  createEnterprise,
  enterpriseManager,
  enterpriseManagerAuth,
  enterpriseManagerChangeModulesPermissions,
  enterpriseManagerDash,
  enterprises,
  home,
  splash,
}

class Bridge<T> extends ChangeNotifier {
  T? _value;
  T? get value => _value;
  set value(T? v) {
    if (!identical(v, _value)) {
      _value = v;
      notifyListeners();
    }
  }
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authBridge = Bridge<Object?>();
  final enterpriseManagerBridge = Bridge<Object?>();

  ref.listen<AsyncValue<Object?>>(authStateControllerProvider, (prev, next) {
    authBridge.value = next.valueOrNull;
  }, fireImmediately: true);

  ref.listen<AsyncValue<Object?>>(
    authManagerStateProvider,
    (prev, next) => enterpriseManagerBridge.value = next.valueOrNull,
    fireImmediately: true,
  );

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    refreshListenable: Listenable.merge([authBridge, enterpriseManagerBridge]),
    routes: [
      authRoute(),
      enterpriseManagerRoute(enterpriseManagerBridge),
      enterprisesRoute(),
      splashRoute(),
    ],

    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
