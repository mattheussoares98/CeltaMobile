import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/sale_request/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase createSaleRequestRoute() => GoRoute(
  path: ':requestCode/create-sale-request',
  name: Routes.createSaleRequest.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final requestCode = int.parse(state.pathParameters['requestCode']!);

    return CreateSaleRequestPage(
      enterpriseCode: enterpriseCode,
      requestCode: requestCode,
    );
  },
);
