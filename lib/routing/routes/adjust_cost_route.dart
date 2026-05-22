import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/adjust_cost/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase adjustCostRoute() => GoRoute(
  path: ':enterpriseCode/adjust-cost',
  name: Routes.adjustCost.name,
  builder: (context, state) {
    return AdjustCostPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
