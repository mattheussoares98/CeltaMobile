import 'package:go_router/go_router.dart';

import '../../../features/sale_request/domain/entities/entities.dart';
import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../../core/domain/entities/entities.dart';
import '../../routing.dart';

RouteBase insertProductRoute() => GoRoute(
  path: 'insert-product',
  name: Routes.saleRequestInsertProduct.name,
  builder: (context, state) {
    final saleRequestId = int.parse(state.pathParameters['saleRequestId']!);
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final customerCode = int.parse(state.pathParameters['customerCode']!);
    final extraMap = state.extra as Map<String, dynamic>;
    final product = extraMap['product'] as BSFProductItemEntity;
    final originalProduct = extraMap['originalProduct'] as ProductEntity;

    return InsertProductPage(
      product: product,
      originalProduct: originalProduct,
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );
  },
);
