import 'package:celta_inventario/features/process_authorization/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase processAuthorizationGoodsReceivingRoute() => GoRoute(
  path: ':processCode/goods-receiving',
  name: Routes.processAuthorizationGoodsReceiving.name,
  builder: (context, state) {
    //TODO test how build the URL on web platform
    return ProcessAuthorizationGoodsReceivingPage(
      processCode: int.parse(state.pathParameters['processCode'].toString()),
    );
  },
);
