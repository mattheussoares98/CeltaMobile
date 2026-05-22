import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/sale_request/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase searchSaleRequestsRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/search-sale-request',
  name: Routes.searchSaleRequests.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);

    return SearchSaleRequestPage(enterpriseCode: enterpriseCode);
  },
);
