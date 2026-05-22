import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/transfer_request/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase productsManagementRoute() => GoRoute(
  path: ':enterpriseDestinyCode/products-management',
  name: Routes.transferRequestProductsManagement.name,
  builder: (context, state) {
    final requestTypeCode = int.parse(
      state.pathParameters['requestTypeCode'].toString(),
    );
    final enterpriseOriginCode = int.parse(
      state.pathParameters['enterpriseOriginCode'].toString(),
    );
    final enterpriseDestinyCode = int.parse(
      state.pathParameters['enterpriseDestinyCode'].toString(),
    );

    return ProductsManagementPage(
      enterpriseOriginCode: enterpriseOriginCode,
      enterpriseDestinyCode: enterpriseDestinyCode,
      requestTypeCode: requestTypeCode,
    );
  },
);
