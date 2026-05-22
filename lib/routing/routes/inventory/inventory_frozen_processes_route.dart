import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/inventory/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase inventoryFrozenProcessesRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/inventory-frozen-processes',
  name: Routes.inventoryFrozenProcesses.name,
  routes: routes,
  builder: (context, state) {
    return FrozenProcessesPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
