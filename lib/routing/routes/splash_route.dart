import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/splash/presentation/pages/splash_page.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase splashRoute() => GoRoute(
  path: '/splash',
  name: Routes.splash.name,
  builder: (context, state) => const SplashPage(),
);
