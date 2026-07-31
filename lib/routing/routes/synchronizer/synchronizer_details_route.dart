import 'package:celta_inventario/features/synchronizer/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase synchronizerDetailsRoute() => GoRoute(
  path: ':errorKey/synchronizer-details',
  name: Routes.synchronizerDetails.name,
  builder: (context, state) {
    return SynchronizerDetailsPage(errorKey: state.pathParameters['errorKey']!);
  },
);
