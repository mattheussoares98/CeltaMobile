import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/adjust_sale_price/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase adjustSalePriceProducts(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/adjust-sale-price-products',
  name: Routes.adjustSalePriceProducts.name,
  routes: routes,
  builder: (context, state) {
    return AdjustSalePriceProductsPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
