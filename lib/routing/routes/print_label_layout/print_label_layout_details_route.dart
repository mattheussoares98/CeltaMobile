import 'package:celta_inventario/features/print_label_layout/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';
import 'package:go_router/go_router.dart';

RouteBase printLabelLayoutDetailsRoute() => GoRoute(
  path: ':labelCode/details',
  name: Routes.printLabelLayoutDetails.name,
  builder: (context, state) {
    final labelCode = int.parse(state.pathParameters['labelCode']!);
    return PrintLabelLayoutDetailsPage(labelCode: labelCode);
  },
);
