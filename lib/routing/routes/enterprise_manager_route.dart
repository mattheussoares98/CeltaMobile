import 'package:go_router/go_router.dart';

import '../../features/enterprise_manager/presentation/pages/pages.dart';
import '../../features/home/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase enterpriseManagerRoute(Bridge<Object?> mgrBridge) => GoRoute(
  path: '/enterprise-manager',
  name: AppRoute.enterpriseManager.name,

  redirect: (context, state) {
    final isLoggedInManager = mgrBridge.value != null;
    final isAtManagerRoot = state.fullPath == '/enterprise-manager';
    final isAtManagerAuth = state.fullPath == '/enterprise-manager/auth';

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
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: 'dashboard',
      name: AppRoute.enterpriseManagerDash.name,
      builder: (context, state) => const EnterpriseManagerPage(),
      routes: [
        GoRoute(
          path: 'permissions/:enterpriseId/:subEnterpriseId',
          name: AppRoute.enterpriseManagerChangeModulesPermissions.name,
          builder: (context, state) {
            final enterpriseId = state.pathParameters['enterpriseId']!;
            final subEnterpriseId = state.pathParameters['subEnterpriseId']!;

            return ChangeModulesPermissionPage(
              enterpriseId: int.parse(enterpriseId),
              subEnterpriseId: int.tryParse(subEnterpriseId),
            );
          },
        ),
        GoRoute(
          path: 'createEnterprise',
          name: AppRoute.createEnterprise.name,
          builder: (context, state) => CreateEnterprisePage(),
        ),
      ],
    ),
    GoRoute(
      path: 'home',
      name: AppRoute.home.name,
      builder: (context, state) => HomePage(),
    ),
  ],
);
