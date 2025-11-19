import 'package:go_router/go_router.dart';

import '../../features/adjust_stock/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase adjustStocksRoute() => GoRoute(
  path: ':enterpriseCode/adjust-stocks',
  name: Routes.adjustStocks.name,
  builder: (context, state) {
    return AdjustStocksPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
