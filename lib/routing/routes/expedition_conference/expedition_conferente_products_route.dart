import 'package:celta_intelligence/utils/utils.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/entities/entities.dart';
import '../../../features/expedition_conference/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase expeditionConferenceProductsRoute() => GoRoute(
  path: 'products-conference/:stepCode/:expeditionControlCode/:documentNumber',
  name: Routes.expeditionConferenceProducts.name,
  builder: (context, state) {
    final enterprise =
        (state.extra as Map?)?['enterprise'] as EnterpriseEntity?;

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
      selectedEnterprise: enterprise,
    );
  },
);
