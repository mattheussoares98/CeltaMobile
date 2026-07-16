import 'package:celta_inventario/features/process_authorization/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase processAuthorizationGRRoute() => GoRoute(
  path: ':processCode/goods-receiving',
  name: Routes.processAuthorizationGR.name,
  builder: (context, state) {
    //TODO test how build the URL on web platform
    return ProcessAuthorizationGRPage(
      processCode: int.parse(state.pathParameters['processCode'].toString()),
    );
  },
);
