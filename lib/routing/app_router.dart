import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../features/auth/presentation/controllers/controllers.dart';
import '../features/auth/presentation/pages/pages.dart';
import '../features/enterprise_manager/presentation/controllers/controllers.dart';
import '../features/enterprise_manager/presentation/pages/pages.dart'
    as enterprise_manager;
import 'not_found_page.dart';

part 'app_router.g.dart';

enum AppRoute {
  auth,
  enterpriseManager,
  enterpriseManagerAuth,
  enterpriseManagerChangeEnabledModules,
  enterpriseManagerDash,
  home,
  splash,
}

class _Bridge<T> extends ChangeNotifier {
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
  final authBridge = _Bridge<Object?>();
  final mgrBridge = _Bridge<Object?>();

  ref.listen<AsyncValue<Object?>>(authStateControllerProvider, (prev, next) {
    authBridge.value = next.valueOrNull;
  }, fireImmediately: true);

  ref.listen<AsyncValue<Object?>>(
    authManagerStateProvider,
    (prev, next) => mgrBridge.value = next.valueOrNull,
    fireImmediately: true,
  );

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    refreshListenable: Listenable.merge([authBridge, mgrBridge]),
    routes: [
      GoRoute(
        path: '/auth',
        name: AppRoute.auth.name,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/enterprise-manager',
        name: AppRoute.enterpriseManager.name,

        redirect: (context, state) {
          final isLoggedInManager = mgrBridge.value != null;
          final isAtManagerRoot =
              state.matchedLocation == '/enterprise-manager';
          final isAtManagerAuth =
              state.matchedLocation == '/enterprise-manager/auth';

          if (!isLoggedInManager && !isAtManagerAuth) {
            return '/enterprise-manager/auth';
          }

          if (isLoggedInManager && (isAtManagerRoot || isAtManagerAuth)) {
            return '/enterprise-manager/dashboard';
          }

          return null;
        },

        routes: [
          GoRoute(
            path: 'auth',
            name: AppRoute.enterpriseManagerAuth.name,
            builder: (context, state) => const enterprise_manager.AuthPage(),
          ),
          GoRoute(
            path: 'dashboard',
            name: AppRoute.enterpriseManagerDash.name,
            builder: (context, state) =>
                const enterprise_manager.EnterpriseManagerPage(),
            routes: [
              GoRoute(
                path: 'permissions/:enterpriseId/:cnpj',
                name: AppRoute.enterpriseManagerChangeEnabledModules.name,
                builder: (context, state) {
                  final enterpriseId = state.pathParameters['enterpriseId']!;
                  final cnpj = state.pathParameters['cnpj']!;

                  return enterprise_manager.ChangeEnabledModulesPage(
                    enterpriseId: enterpriseId,
                    cnpj: cnpj,
                  );
                },
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/splash',
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashPage(),
      ),
    ],

    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
