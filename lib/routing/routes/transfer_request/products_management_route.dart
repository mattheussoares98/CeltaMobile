import 'package:go_router/go_router.dart';

import '../../../features/transfer_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase productsManagementRoute() => GoRoute(
  path: 'products-management/:enterpriseDestinyCode',
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
