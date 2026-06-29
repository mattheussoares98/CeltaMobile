import 'package:celta_inventario/core/domain/entities/entities.dart';
import 'package:celta_inventario/core/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase saleRequestRequestsTypesRoute() => GoRoute(
  path: ':enterpriseCode/requests',
  name: Routes.saleRequestRequestsTypes.name,
  builder: (context, state) {
    final enterpriseCode = int.parse(state.pathParameters['enterpriseCode']!);

    return RequestsTypePage(
      enterpriseCode: enterpriseCode,
      module: Modules.saleRequest,
      onTap: (ref, request) {
        ref
            .read(tryAccessModuleControllerProvider.notifier)
            .tryAccess(
              context: context,
              route: Routes.insertUpdateSaleRequest,
              enterpriseCode: enterpriseCode,
              module: Modules.saleRequest,
              pathParameters: {
                'enterpriseCode': enterpriseCode.toString(),
                'requestTypeCode': request.code.toString(),
                'saleRequestId': 0.toString(),
                'customerCode': 0.toString(),
              },
            );
      },
    );
  },
);
