import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/inventory/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase inventoryProductsRoute() => GoRoute(
  path: ':codigoInternoInvCont/:codigoInternoInventario/products',
  name: Routes.inventoryProducts.name,
  builder: (context, state) {
    final codigoInternoInvCont = int.parse(
      state.pathParameters['codigoInternoInvCont'].toString(),
    );
    final enterpriseCode = int.parse(
      state.pathParameters['enterpriseCode'].toString(),
    );
    final codigoInternoInventario = int.parse(
      state.pathParameters['codigoInternoInventario'].toString(),
    );

    return ProductsPage(
      codigoInternoInvCont: codigoInternoInvCont,
      enterpriseCode: enterpriseCode,
      codigoInternoInventario: codigoInternoInventario,
    );
  },
);
