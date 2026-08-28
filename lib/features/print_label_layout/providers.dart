import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IEcPrintLabelLayoutDatasource ecPrintLabelLayoutDatasource(Ref ref) {
  return EcPrintLabelLayoutDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcPrintLabelLayoutRepository ecPrintLabelLayoutRepository(Ref ref) {
  return EcPrintLabelLayoutRepositoryImpl(
    ref.watch(ecPrintLabelLayoutDatasourceProvider),
  );
}
