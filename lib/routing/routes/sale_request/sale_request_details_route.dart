import 'package:go_router/go_router.dart';

import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase saleRequestDetailsRoute() => GoRoute(
  path: ':saleRequestId/sale-request-details',
  name: Routes.saleRequestDetails.name,
  builder: (context, state) {
    final saleRequestId = int.parse(state.pathParameters['saleRequestId']!);
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);

    return SaleRequestDetailsPage(
      saleRequestId: saleRequestId,
      enterpriseCode: enterpriseCode,
    );
  },
);
