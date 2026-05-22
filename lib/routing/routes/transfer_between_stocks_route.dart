import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/transfer_between_stocks/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase transferBetweenStocksRoute() => GoRoute(
  path: ':enterpriseCode/transfer-between-stocks',
  name: Routes.transferBetweenStocks.name,
  builder: (context, state) {
    return TransferBetweenStocksPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
