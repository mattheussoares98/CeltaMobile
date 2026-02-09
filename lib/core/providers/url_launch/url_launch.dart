import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/url_launch/url_launch.dart';

part 'url_launch.g.dart';

@Riverpod(keepAlive: true)
IUrlLaunchDatasource urlLaunchDatasource(Ref ref) => UrlLaunchDatasource();
