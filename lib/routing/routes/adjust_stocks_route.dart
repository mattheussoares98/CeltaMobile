import 'package:go_router/go_router.dart';

import '../../core/domain/entities/entities.dart';
import '../../features/adjust_stock/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase adjustStocksRoute() => GoRoute(
  path: 'adjust-stocks/:enterpriseCode',
  name: Routes.adjustStocks.name,
  builder: (context, state) {
    final enterprise =
        (state.extra as Map?)?['enterprise'] as EnterpriseEntity?;

    return AdjustStocksPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      selectedEnterprise: enterprise,
    );
  },
);
