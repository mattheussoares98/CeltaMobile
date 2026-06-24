import 'package:celta_inventario/features/products_register/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase productsRegisterCreateProductRoute() => GoRoute(
  path: ':productCode/create',
  name: Routes.productsRegisterCreateProduct.name,
  builder: (context, state) {
    return CreateProductPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      productCode: int.parse(state.pathParameters['productCode'].toString()),
    );
  },
);
