import 'package:celta_inventario/features/print_label_layout/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase printLabelProblemReportRoute() => GoRoute(
  path: 'problem-report',
  name: Routes.printLabelProblemReport.name,
  builder: (context, state) => PrintLabelProblemReportPage(
    labelCode: int.parse(state.pathParameters['labelCode']!),
  ),
);
