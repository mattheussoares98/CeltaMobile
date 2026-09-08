import 'package:celta_inventario/features/print_label_layout/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:go_router/go_router.dart';

RouteBase printLabelLayoutDetailsRoute(List<RouteBase> routes) => GoRoute(
  path: ':labelCode/details',
  name: Routes.printLabelLayoutDetails.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final labelCode = int.parse(state.pathParameters['labelCode']!);
    return PrintLabelLayoutDetailsPage(
      enterpriseCode: enterpriseCode,
      labelCode: labelCode,
      showProblemReportAction: PlatformUtil.isMobile,
    );
  },
  routes: routes,
);
