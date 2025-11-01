import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase homeRoute(List<RouteBase> routes) => GoRoute(
  path: '/home',
  name: Routes.home.name,
  builder: (context, state) => const HomePage(),
  routes: routes,
);
