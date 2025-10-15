import 'package:go_router/go_router.dart';

import '../../../core/domain/entities/entities.dart';
import '../../../features/inventory/domain/entities/entities.dart';
import '../../../features/inventory/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase inventoryCountingsRoute() => GoRoute(
  path: 'inventory-countings-route/:codigoInternoInventario',
  name: Routes.inventoryCountings.name,
  builder: (context, state) {
    final enterprise =
        (state.extra as Map?)?['enterprise'] as EnterpriseEntity?;
    final countings =
        (state.extra as Map?)?['counting'] as List<CountingEntity>?;

    final codigoInternoInventario = int.parse(
      state.pathParameters['codigoInternoInventario'].toString(),
    );
    final enterpriseCode = int.parse(
      state.pathParameters['enterpriseCode'].toString(),
    );

    return CountingsPage(
      codigoInternoInventario: codigoInternoInventario,
      enterpriseCode: enterpriseCode,
      selectedEnterprise: enterprise,
      countings: countings,
    );
  },
);
