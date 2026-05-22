import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/competing_prices/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase concurrentsRoute(List<RouteBase> routes) => GoRoute(
  path: ':researchCode/concurrents',
  name: Routes.competingPricesConcurrents.name,
  routes: routes,
  builder: (context, state) {
    final researchCode = int.parse(
      state.pathParameters['researchCode'].toString(),
    );
    final enterpriseCode = int.parse(
      state.pathParameters['enterpriseCode'].toString(),
    );

    return ConcurrentsPage(
      researchCode: researchCode,
      enterpriseCode: enterpriseCode,
    );
  },
);
