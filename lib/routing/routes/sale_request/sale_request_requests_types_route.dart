import 'package:go_router/go_router.dart';

import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase saleRequestRequestsTypesRoute() => GoRoute(
  path: 'sale-request',
  name: Routes.saleRequestRequestsTypes.name,
  builder: (context, state) {
    return RequestsTypePage();
  },
);
