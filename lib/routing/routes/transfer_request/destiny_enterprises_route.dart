import 'package:go_router/go_router.dart';

import '../../../features/transfer_request/presentation/pages/pages.dart';
import '../../routing.dart';

RouteBase destinyEnterprisesRoute() => GoRoute(
  path: 'destiny-enterprises/:requestTypeCode/:enterpriseOriginCode',
  name: Routes.transferRequestDestinyEnterprises.name,
  builder: (context, state) {
    final requestTypeCode = int.parse(
      state.pathParameters['requestTypeCode'].toString(),
    );
    final enterpriseOriginCode = int.parse(
      state.pathParameters['enterpriseOriginCode'].toString(),
    );

    return DestinyEnterprisesPage(
      requestTypeCode: requestTypeCode,
      enterpriseOriginCode: enterpriseOriginCode,
    );
  },
);
