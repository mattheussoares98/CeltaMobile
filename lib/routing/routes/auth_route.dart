import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase authRoute() => GoRoute(
  path: '/auth',
  name: Routes.auth.name,
  builder: (context, state) => const AuthPage(),
);
