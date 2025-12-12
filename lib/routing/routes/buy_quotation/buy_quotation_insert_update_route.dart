import 'package:go_router/go_router.dart';

import '../../../features/buy_quotation/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase buyQuotationInsertUpdateRoute() => GoRoute(
  path: ':code/insert-update',
  name: Routes.buyQuotationInsertUpdate.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final code = int.tryParse(state.pathParameters['code'] ?? '');

    return InsertUpdatePage(code: code, enterpriseCode: enterpriseCode);
  },
);
