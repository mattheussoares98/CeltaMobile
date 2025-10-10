import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../routing.dart';

RouteBase splashRoute() => GoRoute(
  path: '/splash',
  name: Routes.splash.name,
  builder: (context, state) => const SplashPage(),
);
