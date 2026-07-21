import 'package:celta_inventario/features/buy_request/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase buyRequestDetailsRoute() => GoRoute(
  path: ':buyRequestCode/buy-request-details',
  name: Routes.buyRequestDetails.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final buyRequestCode = int.parse(state.pathParameters['buyRequestCode']!);
    return BuyRequestDetailsPage(
      enterpriseCode: enterpriseCode,
      buyRequestCode: buyRequestCode,
    );
  },
);
