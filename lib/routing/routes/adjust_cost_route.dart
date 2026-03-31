import 'package:go_router/go_router.dart';

import '../../features/adjust_cost/adjust_cost.dart';
import '../routing.dart';

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
