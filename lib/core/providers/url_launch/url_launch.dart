import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/url_launch/url_launch.dart';

part 'url_launch.g.dart';

@Riverpod(keepAlive: true)
IUrlLaunchDatasource urlLaunchDatasource(Ref ref) => UrlLaunchDatasource();
