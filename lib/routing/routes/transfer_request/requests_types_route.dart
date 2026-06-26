import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase transferRequestRquestsTypesRoute(List<RouteBase> routes) => GoRoute(
  path: ':enterpriseCode/transfer-request',
  name: Routes.transferRequestRequestsTypes.name,
  routes: routes,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);
    return RequestsTypePage(
      enterpriseCode: enterpriseCode,
      module: Modules.transferRequest,
      onTap: (ref, request) {
        context.goNamed(
          Routes.transferRequestOriginEnterprises.name,
          pathParameters: {
            'requestTypeCode': request.code.toString(),
            'enterpriseCode': enterpriseCode.toString(),
          },
        );
      },
    );
  },
);
