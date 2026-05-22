import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/hive/hive.dart';
import 'package:celta_inventario/features/enterprises/data/datasource/datasource.dart';
import 'package:celta_inventario/features/enterprises/domain/repository/repository.dart';
import 'package:celta_inventario/features/enterprises/data/repository/repository.dart';

part 'providers.g.dart';

@riverpod
ILastSelectedEnterpriseCodeDatasource lastSelectedEnterpriseCodeDatasource(
  Ref ref,
) {
  return LastSelectedEnterpriseCodeDatasource(
    ref.watch(hiveBoxLastSelectedEnterpriseCodeProvider),
  );
}

@riverpod
ILastSelectedEnterpriseCodeRepository lastSelectedEnterpriseCodeRepository(
  Ref ref,
) {
  return LastSelectedEnterpriseCodeRepositoryImpl(
    ref.watch(lastSelectedEnterpriseCodeDatasourceProvider),
  );
}
