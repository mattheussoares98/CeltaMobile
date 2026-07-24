import 'package:celta_inventario/features/buy_movement/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase buyMovementDetailsRoute() => GoRoute(
  path: ':buyMovementCode/buy-movement-details',
  name: Routes.buyMovementDetails.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final buyMovementCode = int.parse(state.pathParameters['buyMovementCode']!);
    return BuyMovementDetailsPage(
      enterpriseCode: enterpriseCode,
      buyMovementCode: buyMovementCode,
    );
  },
);
