import 'package:go_router/go_router.dart';

import '../../../features/transfer_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase originEnterprisesRoute() => GoRoute(
  path: 'origin-enterprises/:requestTypeCode',
  name: Routes.transferRequestOriginEnterprises.name,
  builder: (context, state) {
    final requestTypeCode = int.parse(
      state.pathParameters['requestTypeCode'].toString(),
    );

    return OriginEnterprisesPage(requestTypeCode: requestTypeCode);
  },
);
