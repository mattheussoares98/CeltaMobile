import 'package:celta_intelligence/core/providers/hive/hive.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/datasource/datasource.dart';

part 'providers.g.dart';

@riverpod
ILocalFavoriteModulesDatasource localFavoriteModulesDatasource(Ref ref) {
  return LocalFavoriteModulesDatasource(
    ref.watch(hiveBoxFavoriteModulesProvider),
  );
}
