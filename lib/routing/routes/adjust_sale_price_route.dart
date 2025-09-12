import 'package:go_router/go_router.dart';

import '../../features/adjust_sale_price/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase adjustSalePrice() => GoRoute(
  path: '/adjustSalePrice',
  name: AppRoute.adjustSalePrice.name,
  builder: (context, state) {
    return AdjustSalePricePage(enterpriseCode: state.extra as int);
  },
);
