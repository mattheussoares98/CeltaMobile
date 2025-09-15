import 'package:go_router/go_router.dart';

import '../../features/enterprises/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase enterprisesRoute(List<RouteBase> routes) => GoRoute(
  path: 'enterprises/:nextRoute',
  name: AppRoute.enterprises.name,
  builder: (context, state) {
    final nextRoute = state.pathParameters['nextRoute'] as String;

    return EnterprisesPage(nextRoute);
  },
  routes: routes,
);
