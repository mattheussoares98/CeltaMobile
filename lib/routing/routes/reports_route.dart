import 'package:go_router/go_router.dart';

import '../../features/reports/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase reportsRoute() => GoRoute(
  path: 'reports',
  name: Routes.reports.name,
  builder: (_, _) => const ReportsPage(),
);
