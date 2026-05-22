import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/home/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase homeRoute(List<RouteBase> routes) => GoRoute(
  path: '/home',
  name: Routes.home.name,
  builder: (context, state) => const HomePage(),
  routes: routes,
);
