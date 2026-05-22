import 'package:go_router/go_router.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_sale_price/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase adjustSalePrice() => GoRoute(
  path: ':plu/adjust-sale-price',
  name: Routes.adjustSalePrice.name,
  builder: (context, state) {
    final enterpriseCode = state.pathParameters['enterpriseCode']!;
    final plu = state.pathParameters['plu']!;

    return AdjustSalePricePage(
      plu: plu,
      enterpriseCode: int.parse(enterpriseCode),
      product: state.extra as ProductEntity?,
    );
  },
);
