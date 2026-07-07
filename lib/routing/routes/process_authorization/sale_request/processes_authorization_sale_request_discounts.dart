import 'package:celta_inventario/features/process_authorization/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase processAuthorizationSaleRequestDiscountsRoute() => GoRoute(
  path: ':processCode/details',
  name: Routes.processAuthorizationSaleRequestDiscounts.name,
  builder: (context, state) {
    return ProcessAuthorizationSaleRequestDiscountsPage(
      processCode: int.parse(state.pathParameters['processCode'].toString()),
    );
  },
);
