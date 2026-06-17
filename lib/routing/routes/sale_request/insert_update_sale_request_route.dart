import 'package:celta_inventario/features/sale_request/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase insertUpdateSaleRequestRoute(List<RouteBase> routes) => GoRoute(
  path: ':requestTypeCode/insert-update',
  name: Routes.insertUpdateSaleRequest.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    final saleRequestId = int.tryParse(
      state.pathParameters['saleRequestId'] ?? '',
    );
    final customerCode = int.tryParse(
      state.pathParameters['customerCode'] ?? '',
    );
    final requestTypeCode = int.tryParse(
      state.pathParameters['requestTypeCode'] ?? '',
    );

    return InsertUpdatePage(
      enterpriseCode: enterpriseCode,
      customerCode: customerCode ?? 0,
      saleRequestId: saleRequestId ?? 0, //!0 is inserting
      requestTypeCode: requestTypeCode,
    );
  },
);
