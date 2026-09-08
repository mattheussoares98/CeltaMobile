import 'package:celta_inventario/features/print_label_layout/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase reportedPrintLabelProblemsRoute() => GoRoute(
  path: 'reported-problems',
  name: Routes.reportedPrintLabelProblems.name,
  builder: (context, state) => const ReportedPrintLabelProblemsPage(),
);
