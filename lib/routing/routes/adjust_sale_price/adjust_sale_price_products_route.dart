import 'package:go_router/go_router.dart';

import '../../../features/adjust_sale_price/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase adjustSalePriceProducts(List<RouteBase> routes) => GoRoute(
  path: 'adjust-sale-price-products/:enterpriseCode',
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
