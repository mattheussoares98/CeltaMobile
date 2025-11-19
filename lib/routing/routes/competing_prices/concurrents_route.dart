import 'package:go_router/go_router.dart';

import '../../../features/competing_prices/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase concurrentsRoute(List<RouteBase> routes) => GoRoute(
  path: 'concurrents/:researchCode',
  name: Routes.competingPricesConcurrents.name,
  routes: routes,
  builder: (context, state) {
    final researchCode = int.parse(
      state.pathParameters['researchCode'].toString(),
    );
    return ConcurrentsPage(researchCode: researchCode);
  },
);
