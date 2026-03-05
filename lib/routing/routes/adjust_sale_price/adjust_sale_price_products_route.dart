import 'package:go_router/go_router.dart';

import '../../../features/adjust_sale_price/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase adjustSalePriceProducts(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/adjust-sale-price-products',
  name: Routes.adjustSalePriceProducts.name,
  routes: routes,
  pageBuilder: (context, state) {
    return NoTransitionPage(
      child: AdjustSalePriceProductsPage(
        enterpriseCode: int.parse(
          state.pathParameters['enterpriseCode'].toString(),
        ),
      ),
    );
  },
);
