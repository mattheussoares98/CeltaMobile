import 'package:celta_inventario/features/products_register/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase productsRegisterRoute() => GoRoute(
  path: ':enterpriseCode/products-register',
  name: Routes.productsRegister.name,
  builder: (context, state) {
    return ProductsRegisterPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
