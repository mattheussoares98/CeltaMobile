import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/buy_quotation/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase buyQuotationsRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/buy-quotations',
  name: Routes.buyQuotations.name,
  routes: routes,
  builder: (context, state) {
    return QuotationsPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
