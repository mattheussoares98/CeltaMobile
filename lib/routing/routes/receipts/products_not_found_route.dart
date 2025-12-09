import 'package:go_router/go_router.dart';

import '../../../features/receipt/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase productsNotFoundRoute() => GoRoute(
  path: 'products-not-found',
  name: Routes.receiptProductsNotFound.name,
  builder: (context, state) {
    final receiptCode = int.parse(state.pathParameters['receiptCode']!);
    return ProductsNotFoundPage(receiptCode: receiptCode);
  },
);
