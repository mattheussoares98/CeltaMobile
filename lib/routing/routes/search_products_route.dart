import 'package:go_router/go_router.dart';

import '../../core/domain/entities/entities.dart';
import '../../features/search_products/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase searchProductsRoute() => GoRoute(
  path: 'search-products/:enterpriseCode',
  name: AppRoute.searchProducts.name,
  builder: (context, state) {
    final enterprise =
        (state.extra as Map?)?['enterprise'] as EnterpriseEntity?;

    return SearchProductsPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      selectedEnterprise: enterprise,
    );
  },
);
