import 'package:celta_inventario/features/process_authorization/domain/entities/entities.dart';
import 'package:celta_inventario/features/process_authorization/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase processAuthorizationDetailsRoute() => GoRoute(
  path: ':processCode/details',
  name: Routes.processAuthorizationDetails.name,
  builder: (context, state) {
    return ProcessAuthorizationDetailsPage(
      processCode: int.parse(state.pathParameters['processCode'].toString()),
      errorType: TypeAccordingToTheCode.fromCode(
        int.parse((state.extra.toString())),
      ),
    );
  },
);
