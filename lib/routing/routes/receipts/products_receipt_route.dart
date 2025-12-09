import 'package:go_router/go_router.dart';

import '../../../features/receipt/domain/entity/entity.dart';
import '../../../features/receipt/presentation/pages/products/products_page.dart';
import '../../routing.dart';

RouteBase productsReceiptRoute(List<RouteBase> routes) => GoRoute(
  path: ':receiptCode/products',
  name: Routes.receiptProducts.name,
  routes: routes,
  builder: (context, state) {
    final receiptCode = int.parse(state.pathParameters['receiptCode']!);
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final receipt = state.extra as ReceiptEntity?;

    return ProductsPage(
      receiptCode: receiptCode,
      receipt: receipt,
      enterpriseCode: enterpriseCode,
    );
  },
);
