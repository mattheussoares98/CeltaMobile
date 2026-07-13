import 'package:celta_inventario/features/process_authorization/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase processAuthorizationSaleRequestDiscountsRoute() => GoRoute(
  path: ':processCode/:pageType',
  name: Routes.processAuthorizationSaleRequest.name,
  builder: (context, state) {
    return ProcessAuthorizationSaleRequestBasePage(
      processCode: int.parse(state.pathParameters['processCode'].toString()),
      pageType: PageType.fromName(state.pathParameters['pageType'].toString()),
    );
  },
);
