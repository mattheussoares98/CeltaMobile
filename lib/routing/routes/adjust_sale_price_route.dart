import 'package:go_router/go_router.dart';

import '../../features/adjust_sale_price/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase adjustSalePriceProducts() => GoRoute(
  path: '/adjust-sale-price-products',
  name: AppRoute.adjustSalePriceProducts.name,
  builder: (context, state) {
    return AdjustSalePriceProductsPage(enterpriseCode: state.extra as int);
  },
);
