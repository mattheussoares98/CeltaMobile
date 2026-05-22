import 'package:go_router/go_router.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/adjust_stock/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase adjustStocksRoute() => GoRoute(
  path: ':enterpriseCode/adjust-stocks',
  name: Routes.adjustStocks.name,
  builder: (context, state) {
    return AdjustStocksPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      product: state.extra as ProductEntity?,
    );
  },
);
