import 'package:go_router/go_router.dart';

import '../../../features/inventory/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase inventoryProductsRoute() => GoRoute(
  path: 'products/:codigoInternoInvCont',
  name: Routes.inventoryProducts.name,
  builder: (context, state) {
    final codigoInternoInvCont = int.parse(
      state.pathParameters['codigoInternoInvCont'].toString(),
    );

    return ProductsPage(codigoInternoInvCont: codigoInternoInvCont);
  },
);
