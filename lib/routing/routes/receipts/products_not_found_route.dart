import 'package:celta_inventario/features/receipt/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase productsNotFoundRoute() => GoRoute(
  path: 'products-not-found',
  name: Routes.receiptProductsNotFound.name,
  builder: (context, state) {
    final receiptCode = int.parse(state.pathParameters['receiptCode']!);
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    return ProductsNotFoundPage(
      receiptCode: receiptCode,
      enterpriseCode: enterpriseCode,
    );
  },
);
