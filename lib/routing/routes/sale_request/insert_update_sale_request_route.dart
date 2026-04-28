import 'package:go_router/go_router.dart';

import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase insertUpdateSaleRequestRoute(List<RouteBase> routes) => GoRoute(
  path: 'insert-update',
  name: Routes.insertUpdateSaleRequest.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final saleRequestId = int.tryParse(
      state.pathParameters['saleRequestId'] ?? '',
    );
    final customerCode = int.parse(state.pathParameters['customerCode']!);

    return InsertUpdatePage(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId ?? 0, //!0 is inserting
    );
  },
);
