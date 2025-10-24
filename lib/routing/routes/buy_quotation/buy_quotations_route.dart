import 'package:go_router/go_router.dart';

import '../../../features/buy_quotation/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase buyQuotationsRoute(List<RouteBase> routes) => GoRoute(
  path: 'buy-quotations/:enterpriseCode',
  name: Routes.buyQuotations.name,
  routes: routes,
  builder: (context, state) {
    return QuotationsPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
