import 'package:go_router/go_router.dart';

import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase saleRequestRoute() => GoRoute(
  path: ':requestCode/sale-request',
  name: Routes.saleRequest.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final requestCode = int.parse(state.pathParameters['requestCode']!);

    return CreateSaleRequestPage(
      enterpriseCode: enterpriseCode,
      requestCode: requestCode,
    );
  },
);
