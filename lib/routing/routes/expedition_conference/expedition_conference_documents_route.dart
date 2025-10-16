import 'package:go_router/go_router.dart';

import '../../../features/expedition_conference/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase expeditionConferenceDocumentsRoute(List<RouteBase> routes) => GoRoute(
  path: 'expedition-conference-documents/:enterpriseName/:enterpriseCode',
  name: Routes.expeditionConferenceDocuments.name,
  routes: routes,
  builder: (context, state) {
    return DocumentsPage(
      enterpriseCode: int.parse(
        state.pathParameters['enterpriseCode'].toString(),
      ),
      enterpriseName: state.pathParameters['enterpriseName']!,
    );
  },
);
