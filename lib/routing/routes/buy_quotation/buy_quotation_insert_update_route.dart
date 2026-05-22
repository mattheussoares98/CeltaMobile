import 'package:go_router/go_router.dart';

import 'package:celta_inventario/features/buy_quotation/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase buyQuotationInsertUpdateRoute() => GoRoute(
  path: ':code/insert-update',
  name: Routes.buyQuotationInsertUpdate.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final code = int.parse(state.pathParameters['code']!);

    return InsertUpdatePage(code: code, enterpriseCode: enterpriseCode);
  },
);
