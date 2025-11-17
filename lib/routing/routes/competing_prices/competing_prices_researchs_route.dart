import 'package:go_router/go_router.dart';

import '../../../features/competing_prices/presentation/pages/cometing_prices_researchs.dart';
import '../../routing.dart';

RouteBase competingPricesResearchsRoute(List<RouteBase> routes) => GoRoute(
  path: 'competing-prices-researchs',
  name: Routes.competingPricesResearchs.name,
  routes: routes,
  builder: (context, state) {
    return const CompetingPricesResearchs();
  },
);
