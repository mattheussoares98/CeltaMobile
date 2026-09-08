import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/core/providers/supabase/supabase.dart';
import 'package:celta_inventario/features/print_label_layout/data/datasource/datasource.dart';
import 'package:celta_inventario/features/print_label_layout/data/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/data/services/services.dart';
import 'package:celta_inventario/features/print_label_layout/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/print_label_layout/domain/services/services.dart';
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

@riverpod
ISupabasePrintLabelProblemReportDatasource
supabasePrintLabelProblemReportDatasource(Ref ref) {
  return SupabasePrintLabelProblemReportDatasource(
    ref.watch(supabaseClientProvider).functions,
  );
}

@riverpod
IPrintLabelProblemReportRepository printLabelProblemReportRepository(Ref ref) {
  return PrintLabelProblemReportRepositoryImpl(
    ref.watch(supabasePrintLabelProblemReportDatasourceProvider),
  );
}

@riverpod
IPrintLabelProblemReportImageService printLabelProblemReportImageService(
  Ref ref,
) {
  return PrintLabelProblemReportImageService();
}

@riverpod
IPrintLabelProblemReportEnvironmentService
printLabelProblemReportEnvironmentService(Ref ref) {
  return PrintLabelProblemReportEnvironmentService();
}
