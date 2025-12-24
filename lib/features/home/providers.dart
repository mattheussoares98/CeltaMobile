import 'package:celta_intelligence/core/providers/hive/hive.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/datasource/datasource.dart';
import 'domain/repository/repository.dart';

part 'providers.g.dart';

@riverpod
IFavoriteModulesDatasource localFavoriteModulesDatasource(Ref ref) {
  return LocalFavoriteModulesDatasource(
    ref.watch(hiveBoxFavoriteModulesProvider),
  );
}

@riverpod
IFavoriteModulesRepository localFavoriteModulesRepository(Ref ref) {
  return LocalFavoriteModulesRepositoryImpl(
    ref.watch(localFavoriteModulesDatasourceProvider),
  );
}
