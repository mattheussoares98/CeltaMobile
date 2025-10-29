import 'package:go_router/go_router.dart';

import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase saleRequestRoute() => GoRoute(
  path: 'sale-request',
  name: Routes.saleRequestRequestsTypes.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);

    return SaleRequestPage(enterpriseCode: enterpriseCode);
  },
);
