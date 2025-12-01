import 'package:go_router/go_router.dart';

import '../../../features/receipt/presentation/pages/products/products_page.dart';
import '../../routing.dart';

RouteBase productsReceiptRoute() => GoRoute(
  path: ':receiptCode/products',
  name: Routes.receiptProducts.name,
  builder: (context, state) {
    final receiptCode = int.parse(state.pathParameters['receiptCode']!);

    return ProductsPage(receiptCode: receiptCode);
  },
);
