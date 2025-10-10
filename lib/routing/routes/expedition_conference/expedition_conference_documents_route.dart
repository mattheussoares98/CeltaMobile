import 'package:go_router/go_router.dart';

import '../../../core/domain/entities/entities.dart';
import '../../../features/expedition_conference/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase expeditionConferenceDocumentsRoute(List<RouteBase> routes) => GoRoute(
  path: 'expedition-conference/:enterpriseCode',
  name: Routes.expeditionConference.name,
  routes: routes,
  builder: (context, state) {
    final enterprise =
        (state.extra as Map?)?['enterprise'] as EnterpriseEntity?;

    return DocumentsPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      selectedEnterprise: enterprise,
    );
  },
);
