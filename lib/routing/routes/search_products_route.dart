import 'package:go_router/go_router.dart';

import '../../features/search_products/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase searchProductsRoute() => GoRoute(
  path: ':enterpriseCode/search-products',
  name: Routes.searchProducts.name,
  builder: (context, state) {
    return SearchProductsPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
