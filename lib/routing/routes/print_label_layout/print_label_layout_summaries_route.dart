import 'package:celta_inventario/features/print_label_layout/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase printLabelLayoutSummariesRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/print-label-layouts',
  name: Routes.printLabelLayoutSummaries.name,
  routes: routes,
  builder: (context, state) {
    return PrintLabelLayoutSummariesPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
