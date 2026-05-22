import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/sale_request/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase saleRequestDetailsRoute(List<RouteBase> routes) => GoRoute(
  path: ':saleRequestId/:customerCode/sale-request-details',
  name: Routes.saleRequestDetails.name,
  routes: routes,
  builder: (context, state) {
    final saleRequestId = int.parse(state.pathParameters['saleRequestId']!);
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final customerCode = int.parse(state.pathParameters['customerCode']!);

    return SaleRequestDetailsPage(
      saleRequestId: saleRequestId,
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
    );
  },
);
