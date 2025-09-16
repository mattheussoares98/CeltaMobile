import 'package:go_router/go_router.dart';

import '../../core/domain/entities/entities.dart';
import '../../features/adjust_sale_price/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase adjustSalePrice() => GoRoute(
  path: 'adjust-sale-price/:plu',
  name: AppRoute.adjustSalePrice.name,
  builder: (context, state) {
    final enterpriseCode = state.pathParameters['enterpriseCode']!;
    final plu = state.pathParameters['plu']!;

    final product = (state.extra as Map?)?['product'] as ProductEntity?;

    return AdjustSalePricePage(
      plu: plu,
      enterpriseCode: int.parse(enterpriseCode),
      product: product,
    );
  },
);
