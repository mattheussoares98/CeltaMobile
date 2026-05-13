import 'package:go_router/go_router.dart';

import '../../../core/domain/entities/entities.dart';
import '../../../features/sale_request/domain/entities/entities.dart';
import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase insertProductRoute() => GoRoute(
  path: 'insert-product',
  name: Routes.saleRequestInsertProduct.name,
  builder: (context, state) {
    final extraMap = state.extra as Map<String, dynamic>;
    final product = extraMap['product'] as BSFProductItemEntity;
    final originalProduct = extraMap['originalProduct'] as ProductEntity;

    return InsertProductPage(
      product: product,
      originalProduct: originalProduct,
      heroTag: extraMap['heroTag'] as String?,
    );
  },
);
