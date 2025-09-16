import 'package:go_router/go_router.dart';

import '../../core/domain/entities/entities.dart';
import '../../features/adjust_sale_price/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase adjustSalePriceProducts(List<RouteBase> routes) => GoRoute(
  path: 'adjust-sale-price-products/:enterpriseCode',
  name: AppRoute.adjustSalePriceProducts.name,
  routes: routes,
  builder: (context, state) {
    final enterprise =
        (state.extra as Map?)?['enterprise'] as EnterpriseEntity?;

    return AdjustSalePriceProductsPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      selectedEnterprise: enterprise,
    );
  },
);
