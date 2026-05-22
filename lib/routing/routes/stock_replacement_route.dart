import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/stock_replacement/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase stockReplacementRoute() => GoRoute(
  path: ':enterpriseCode/stock-replacement',
  name: Routes.stockReplacement.name,
  builder: (context, state) {
    return StockReplacementPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
