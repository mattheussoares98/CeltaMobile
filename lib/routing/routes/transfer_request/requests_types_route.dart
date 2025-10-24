import 'package:go_router/go_router.dart';

import '../../../features/transfer_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase transferRequestRquestsTypesRoute(List<RouteBase> routes) => GoRoute(
  path: 'transfer-request',
  name: Routes.transferRequestRequestsTypes.name,
  routes: routes,
  builder: (context, state) {
    return TransferRequestRequestsTypesPage();
  },
);
