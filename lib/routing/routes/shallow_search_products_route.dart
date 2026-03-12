import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase shallowSearchProductsRoute() => GoRoute(
  path: 'shallow-products',
  name: Routes.shallowSearchProducts.name,
  builder: (context, state) {
    final controller = state.extra as TextEditingController?;
    return ShallowSearchProductsPage(controller: controller);
  },
);
