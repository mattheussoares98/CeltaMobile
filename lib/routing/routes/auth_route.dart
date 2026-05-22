import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/auth/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase authRoute() => GoRoute(
  path: '/auth',
  name: Routes.auth.name,
  builder: (context, state) => const AuthPage(),
);
