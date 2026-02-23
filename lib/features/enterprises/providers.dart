import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/hive/hive.dart';
import 'data/datasource/datasource.dart';
import 'domain/repository/repository.dart';

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
