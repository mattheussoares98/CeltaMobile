import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/competing_prices/presentation/pages/researchs/researchs.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase competingPricesResearchsRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/competing-prices-researchs',
  name: Routes.competingPricesResearchs.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(
      state.pathParameters['enterpriseCode'].toString(),
    );
    return ResearchsPage(enterpriseCode: enterpriseCode);
  },
);
