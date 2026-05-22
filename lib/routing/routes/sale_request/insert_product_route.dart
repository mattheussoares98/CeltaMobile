import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase insertProductRoute() => GoRoute(
  path: 'insert-product',
  name: Routes.saleRequestInsertProduct.name,
  builder: (context, state) {
    final extraMap = state.extra as Map<String, dynamic>;
    final product = extraMap['product'] as BSFProductItemEntity;
    final originalProduct = extraMap['originalProduct'] as ProductEntity;
    final container = extraMap['container'] as ProviderContainer;

    return InsertProductPage(
      product: product,
      originalProduct: originalProduct,
      heroTag: extraMap['heroTag'] as String?,
      container: container,
    );
  },
);
