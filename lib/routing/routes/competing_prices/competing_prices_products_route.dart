import 'package:go_router/go_router.dart';

import '../../../features/competing_prices/presentation/pages/products/products_page.dart';
import '../../routing.dart';

RouteBase competingPricesProductsRoute() => GoRoute(
  path: ':concurrentCode/products',
  name: Routes.competingPricesProducts.name,
  builder: (context, state) {
    final concurrentCode = int.parse(
      state.pathParameters['concurrentCode'].toString(),
    );
    final researchCode = int.parse(
      state.pathParameters['researchCode'].toString(),
    );
    return ProductsPage(
      researchCode: researchCode,
      concurrentCode: concurrentCode,
    );
  },
);
