import 'package:celta_inventario/features/buy_movement/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase shallowBuyMovementRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/shallow-buy-movement',
  name: Routes.shallowBuyMovement.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    return ShallowBuyMovementsPage(enterpriseCode: enterpriseCode);
  },
);
