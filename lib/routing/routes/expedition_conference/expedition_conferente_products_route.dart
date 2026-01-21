import 'package:celta_inventario/utils/utils.dart';
import 'package:go_router/go_router.dart';

import '../../../features/expedition_conference/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase expeditionConferenceProductsRoute() => GoRoute(
  path: '/:stepCode/:expeditionControlCode/:documentNumber/products-conference',
  name: Routes.expeditionConferenceProducts.name,
  builder: (context, state) {
    final expeditionControlCode = state.pathParameters['expeditionControlCode']!
        .toInt()!;
    final stepCode = state.pathParameters['stepCode']!.toInt()!;
    final documentNumber = state.pathParameters['documentNumber']!;
    final enterpriseCode = state.pathParameters['enterpriseCode']!.toInt()!;

    return ProductsConferencePage(
      expeditionControlCode: expeditionControlCode,
      stepCode: stepCode,
      documentNumber: documentNumber,
      enterpriseCode: enterpriseCode,
    );
  },
);
