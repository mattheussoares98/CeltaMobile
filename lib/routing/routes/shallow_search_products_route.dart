import 'package:go_router/go_router.dart';

import '../../core/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase shallowSearchProductsRoute() => GoRoute(
  path: 'shallow-products',
  name: Routes.shallowSearchProducts.name,
  builder: (context, state) {
    final initialText = state.extra as String?;
    return ShallowSearchProductsPage(initialText: initialText);
  },
);
