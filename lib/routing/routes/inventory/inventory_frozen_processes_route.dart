import 'package:go_router/go_router.dart';

import '../../../features/inventory/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase inventoryFrozenProcessesRoute(List<RouteBase> routes) => GoRoute(
  path: 'inventory-frozen-processes/:enterpriseName/:enterpriseCode',
  name: Routes.inventoryFrozenProcesses.name,
  routes: routes,
  builder: (context, state) {
    return FrozenProcessesPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      enterpriseName: state.pathParameters['enterpriseName']!,
    );
  },
);
