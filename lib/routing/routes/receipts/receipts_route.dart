import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/receipt/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase receiptsRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/receipts',
  name: Routes.receipts.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);

    return ReceiptsPage(enterpriseCode: enterpriseCode);
  },
);
