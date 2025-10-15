import 'package:go_router/go_router.dart';

import '../../../core/domain/entities/entities.dart';
import '../../../features/inventory/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase inventoryFrozenProcessesRoute(List<RouteBase> routes) => GoRoute(
  path: 'inventory-frozen-processes/:enterpriseCode',
  name: Routes.expeditionConferenceDocuments.name,
  routes: routes,
  builder: (context, state) {
    final enterprise =
        (state.extra as Map?)?['enterprise'] as EnterpriseEntity?;

    return FrozenProcessesPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      selectedEnterprise: enterprise,
    );
  },
);
