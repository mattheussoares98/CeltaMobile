import 'package:go_router/go_router.dart';

import '../../core/presentation/pages/pages.dart';
import '../routing.dart';

RouteBase downloadAppRoute() => GoRoute(
  path: '/download-app',
  name: Routes.downloadApp.name,
  builder: (context, state) => const DownloadAppPage(),
);
