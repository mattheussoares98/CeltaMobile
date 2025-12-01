import 'package:go_router/go_router.dart';

import '../../../features/receipt/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase receiptsRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/receipts',
  name: Routes.receipts.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);

    return ReceiptsPage(enterpriseCode: enterpriseCode);
  },
);
