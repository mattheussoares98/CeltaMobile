import 'package:go_router/go_router.dart';

import '../../../features/inventory/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase inventoryCountingsRoute() => GoRoute(
  path: 'inventory-countings-route/:codigoInternoInventario',
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
