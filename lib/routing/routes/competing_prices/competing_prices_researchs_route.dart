import 'package:go_router/go_router.dart';

import '../../../features/competing_prices/presentation/pages/cometing_prices_researchs.dart';
import '../../routing.dart';

RouteBase competingPricesResearchsRoute(List<RouteBase> routes) => GoRoute(
  path: 'competing-prices-researchs/:enterpriseCode',
  name: Routes.competingPricesResearchs.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(
      state.pathParameters['enterpriseCode'].toString(),
    );
    return CompetingPricesResearchs(enterpriseCode: enterpriseCode);
  },
);
