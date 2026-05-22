import 'package:go_router/go_router.dart';

import 'package:celta_inventario/core/presentation/pages/pages.dart';
import 'package:celta_inventario/routing/routing.dart';

RouteBase downloadAppRoute() => GoRoute(
  path: '/download-app',
  name: Routes.downloadApp.name,
  builder: (context, state) => const DownloadAppPage(),
);
