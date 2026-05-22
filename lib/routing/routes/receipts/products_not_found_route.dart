import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/receipt/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase productsNotFoundRoute() => GoRoute(
  path: 'products-not-found',
  name: Routes.receiptProductsNotFound.name,
  builder: (context, state) {
    final receiptCode = int.parse(state.pathParameters['receiptCode']!);
    return ProductsNotFoundPage(receiptCode: receiptCode);
  },
);
