import 'package:go_router/go_router.dart';

import '../../features/enterprises/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase enterprisesRoute() => GoRoute(
  path: '/enterprises',
  name: AppRoute.enterprises.name,
  builder: (context, state) => const EnterprisesPage(),
);
