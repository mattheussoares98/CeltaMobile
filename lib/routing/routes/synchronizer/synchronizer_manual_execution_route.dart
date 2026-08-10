import 'package:celta_inventario/features/synchronizer/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase synchronizerManualExecutionRoute() => GoRoute(
  path: 'manualExecution',
  name: Routes.synchronizerManualExecution.name,
  builder: (context, state) {
    return const SynchronizerManualExecutionPage();
  },
);
