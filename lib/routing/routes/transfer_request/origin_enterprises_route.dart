import 'package:go_router/go_router.dart';

import '../../../features/transfer_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase originEnterprisesRoute(List<RouteBase> routes) => GoRoute(
  path: ':requestTypeCode/origin-enterprises',
  name: Routes.transferRequestOriginEnterprises.name,
  routes: routes,
  builder: (context, state) {
    final requestTypeCode = int.parse(
      state.pathParameters['requestTypeCode'].toString(),
    );

    return OriginEnterprisesPage(requestTypeCode: requestTypeCode);
  },
);
