import 'package:go_router/go_router.dart';

import '../../core/domain/entities/entities.dart';
import '../../features/adjust_sale_price/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase adjustSalePriceProducts() => GoRoute(
  path: 'adjust-sale-price-products/:enterpriseCode',
  name: AppRoute.adjustSalePriceProducts.name,
  builder: (context, state) {
    return AdjustSalePriceProductsPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      selectedEnterprise: state.extra as EnterpriseEntity?,
    );
  },
);
