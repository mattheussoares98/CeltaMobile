import 'package:go_router/go_router.dart';

import '../../features/transfer_between_stocks/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase transferBetweenStocksRoute() => GoRoute(
  path: 'transfer-between-stocks/:enterpriseCode',
  name: Routes.transferBetweenStocks.name,
  builder: (context, state) {
    return TransferBetweenStocksPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
