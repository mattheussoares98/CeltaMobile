import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/data/datasource/app_version/app_version.dart';

part 'app_version.g.dart';

@riverpod
ILoadAppVersionDatasource loadAppVersionDatasource(Ref ref) {
  return LoadAppVersionDatasource();
}
