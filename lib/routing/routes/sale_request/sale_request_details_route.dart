import 'package:go_router/go_router.dart';

import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase saleRequestDetailsRoute(List<RouteBase> routes) => GoRoute(
  path: ':saleRequestId/:customerCode/sale-request-details',
  name: Routes.saleRequestDetails.name,
  routes: routes,
  builder: (context, state) {
    return const SaleRequestDetailsPage();
  },
);
