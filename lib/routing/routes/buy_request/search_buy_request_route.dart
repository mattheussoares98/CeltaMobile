import 'package:celta_inventario/features/buy_request/presentation/pages/search/search.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase searchBuyRequestRoute() => GoRoute(
  path: ':enterpriseCode/search-buy-request',
  name: Routes.searchBuyRequests.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    return ShallowBuyRequestsPage(enterpriseCode: enterpriseCode);
  },
);
