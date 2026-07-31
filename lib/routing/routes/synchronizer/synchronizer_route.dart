import 'package:celta_inventario/features/synchronizer/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase synchronizerRoute() => GoRoute(
  path: 'synchronizer',
  name: Routes.synchronizer.name,
  builder: (context, state) {
    return const SynchronizerPage();
  },
);
