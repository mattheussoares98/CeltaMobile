import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase homeRoute() => GoRoute(
  path: '/home',
  name: AppRoute.home.name,
  builder: (context, state) => HomePage(),
);
