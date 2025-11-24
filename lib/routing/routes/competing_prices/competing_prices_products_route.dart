import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../features/competing_prices/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase competingPricesProductsRoute() => GoRoute(
  path: ':concurrentCode/products',
  name: Routes.competingPricesProducts.name,
  builder: (context, state) {
    final concurrentCode = int.parse(
      state.pathParameters['concurrentCode'].toString(),
    );
    return const SizedBox();
  },
);
