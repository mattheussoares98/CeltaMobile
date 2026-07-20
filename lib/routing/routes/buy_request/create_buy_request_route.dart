import 'package:celta_inventario/features/buy_request/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase createBuyRequestRoute() => GoRoute(
  path: ':enterpriseCode/create-buy-request',
  name: Routes.createBuyRequest.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    return CreateBuyRequestPage(enterpriseCode: enterpriseCode);
  },
);
