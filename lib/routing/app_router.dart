import 'package:celta_intelligence/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/controllers/controllers.dart';
import '../features/auth/presentation/pages/pages.dart';
import '../features/enterprise_manager/presentation/pages/pages.dart';
import 'not_found_page.dart';

part 'app_router.g.dart';

enum AppRoute { auth, enterpriseManager, home, splash }

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final loggedIn = authState.value != null;
      final onAuthRoute = state.matchedLocation == '/auth';

      if (!loggedIn && !onAuthRoute) {
        return '/auth';
      }

      if (loggedIn && onAuthRoute) {
        return '/splash';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        name: AppRoute.auth.name,
        // pageBuilder: (context, state) =>
        //     const MaterialPage(fullscreenDialog: true, child: AuthPage()),
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/enterprise-manager',
        name: AppRoute.enterpriseManager.name,
        builder: (context, state) => const EnterpriseManagerPage(),
      ),
      GoRoute(
        path: '/splash',
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashPage(),
      ),
      // GoRoute(
      //   path: '/',
      //   name: AppRoute.home.name,
      //   builder: (context, state) => const HomePage(), // Create this screen
      //   routes: [
      //     GoRoute(
      //       path: 'company',
      //       name: AppRoute.company.name,
      //       builder: (context, state) => const CompanyPage(),
      //       routes: [
      //         GoRoute(
      //           path: 'editUnit/:unitId',
      //           name: AppRoute.editUnit.name,
      //           builder: (context, state) {
      //             final unitId = state.pathParameters['unitId']!;
      //             return CreateOrEditUnitPage(unitId: unitId);
      //           },
      //         ),
      //         GoRoute(
      //           path: 'createUnit/:companyId',
      //           name: AppRoute.createUnit.name,
      //           builder: (context, state) {
      //             final companyId = state.pathParameters['companyId']!;
      //             return CreateOrEditUnitPage(companyId: companyId);
      //           },
      //         ),
      //         GoRoute(
      //           path: 'createCompany',
      //           name: AppRoute.createCompany.name,
      //           builder: (context, state) => CreateCompanyPage(),
      //         ),
      //       ],
      //     ),
      //     GoRoute(
      //       path: 'invites',
      //       name: AppRoute.invites.name,
      //       builder: (context, state) => const InvitesPage(),
      //     ),
      //     GoRoute(
      //       path: 'permissions',
      //       name: AppRoute.permissions.name,
      //       builder: (context, state) => const PermissionsPage(),
      //       routes: [
      //         GoRoute(
      //           path: 'editPermissionGroup/:companyId/:groupId',
      //           name: AppRoute.editPermissionGroup.name,
      //           builder: (context, state) => EditPermissionGroupPage(
      //             companyId: state.pathParameters['companyId']!,
      //             groupId: state.pathParameters['groupId']!,
      //           ),
      //         ),
      //       ],
      //     ),
      //     GoRoute(
      //       path: 'users',
      //       name: AppRoute.users.name,
      //       builder: (context, state) => const UsersPage(),
      //     ),
      //   ],
      // ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
