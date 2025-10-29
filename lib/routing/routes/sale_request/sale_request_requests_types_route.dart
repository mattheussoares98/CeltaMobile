import 'package:go_router/go_router.dart';

import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase saleRequestRequestsTypesRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/requests',
  name: Routes.saleRequestRequestsTypes.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);

    return RequestsTypePage(enterpriseCode: enterpriseCode);
  },
);
