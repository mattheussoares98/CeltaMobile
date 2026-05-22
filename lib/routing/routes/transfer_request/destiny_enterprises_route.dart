import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/transfer_request/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase destinyEnterprisesRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseOriginCode/destiny-enterprises',
  name: Routes.transferRequestDestinyEnterprises.name,
  routes: routes,
  builder: (context, state) {
    final requestTypeCode = int.parse(
      state.pathParameters['requestTypeCode'].toString(),
    );
    final enterpriseOriginCode = int.parse(
      state.pathParameters['enterpriseOriginCode'].toString(),
    );

    return DestinyEnterprisesPage(
      requestTypeCode: requestTypeCode,
      enterpriseOriginCode: enterpriseOriginCode,
    );
  },
);
