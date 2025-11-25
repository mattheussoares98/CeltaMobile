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
    final enterpriseCode = int.parse(
      state.pathParameters['enterpriseCode'].toString(),
    );

    final extra = state.extra as Map<String, dynamic>;

    final researchName = extra['researchName'] as String?;
    final concurrentName = extra['concurrentName'] as String?;

    return ProductsPage(
      researchCode: researchCode,
      concurrentCode: concurrentCode,
      enterpriseCode: enterpriseCode,
      researchName: researchName,
      concurrentName: concurrentName,
    );
  },
);
