import 'package:celta_inventario/features/products_register/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase productsRegisterSearchProductsRoute(List<RouteBase> routes) =>
    GoRoute(
      path: ':enterpriseCode/products-register',
      name: Routes.productsRegisterSearchProduct.name,
      routes: routes,
      builder: (context, state) {
        return SearchProductsPage(
          enterpriseCode: int.parse(
            state.pathParameters['enterpriseCode'].toString(),
          ),
        );
      },
    );
