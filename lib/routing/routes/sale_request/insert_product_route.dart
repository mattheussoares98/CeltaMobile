import 'package:go_router/go_router.dart';

import '../../../features/sale_request/domain/entities/entities.dart';
import '../../../features/sale_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase insertProductRoute() => GoRoute(
  path: 'insert-product',
  name: Routes.saleRequestInsertProduct.name,
  builder: (context, state) {
    final saleRequestId = int.parse(state.pathParameters['saleRequestId']!);
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final customerCode = int.parse(state.pathParameters['customerCode']!);
    final product = state.extra as BSFProductItemEntity;

    return InsertProductPage(
      product: product,
      enterpriseCode: enterpriseCode,
      customerCode: customerCode,
      saleRequestId: saleRequestId,
    );
  },
);
