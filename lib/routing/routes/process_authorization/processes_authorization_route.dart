import 'package:celta_inventario/features/process_authorization/presentation/pages/process_authorization/process_authorization_page.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase processesAuthorizationRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/processes-authorization',
  name: Routes.processAuthorization.name,
  routes: routes,
  builder: (context, state) {
    return ProcessAuthorizationPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
    );
  },
);
