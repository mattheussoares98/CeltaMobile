import 'package:go_router/go_router.dart';

import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase searchSaleRequestsRoute() => GoRoute(
  path: ':enterpriseCode/search-sale-request',
  name: Routes.searchSaleRequests.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);

    return SearchSaleRequestPage(enterpriseCode: enterpriseCode);
  },
);
