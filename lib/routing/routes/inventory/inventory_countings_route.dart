import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/inventory/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase inventoryCountingsRoute() => GoRoute(
  path: ':codigoInternoInventario/countings',
  name: Routes.inventoryCountings.name,
  builder: (context, state) {
    final codigoInternoInventario = int.parse(
      state.pathParameters['codigoInternoInventario'].toString(),
    );
    final enterpriseCode = int.parse(
      state.pathParameters['enterpriseCode'].toString(),
    );

    return CountingsPage(
      codigoInternoInventario: codigoInternoInventario,
      enterpriseCode: enterpriseCode,
    );
  },
);
