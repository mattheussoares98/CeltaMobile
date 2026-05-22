import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/reports/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase reportsRoute() => GoRoute(
  path: 'reports',
  name: Routes.reports.name,
  builder: (_, _) => const ReportsPage(),
);
