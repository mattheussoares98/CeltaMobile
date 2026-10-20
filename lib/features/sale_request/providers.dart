import 'package:celta_inventario/localization/providers.dart';
import 'package:celta_inventario/core/providers/hive/hive.dart';
import 'package:celta_inventario/core/providers/http/http.dart';
import 'package:celta_inventario/features/sale_request/data/datasource/datasource.dart';
import 'package:celta_inventario/features/sale_request/data/repository/repository.dart';
import 'package:celta_inventario/features/sale_request/domain/entities/entities.dart';
import 'package:celta_inventario/features/sale_request/domain/repository/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
IPrintSaleRequestRepository printSaleRequestRepository(Ref ref) {
  return PrintSaleRequestRepositoryImpl(
    ref.watch(printBsfSaleRequestDatasourceProvider),
  );
}

@riverpod
ILocalIpPrintSaleRequestDatasource localIpPrintSaleRequestDatasource(Ref ref) {
  return LocalIpPrintSaleRequestDatasource(
    ref.watch(hiveBoxSaleRequestProvider),
  );
}

@riverpod
ILocalIpPrintSaleRequestRepository localIpPrintSaleRequestRepository(Ref ref) {
  return LocalIpPrintSaleRequestRepositoryImpl(
    ref.watch(localIpPrintSaleRequestDatasourceProvider),
  );
}

@riverpod
IGeneratePdfRepository generatePdfRepository(Ref ref) {
  return GeneratePdfRepositoryImpl(ref.watch(bSFGeneratePdfDatasourceProvider));
}

@riverpod
IEcSaleRequestsDatasource ecSaleRequestsDatasource(Ref ref) {
  return EcSaleRequestsDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcSaleRequestsRepository ecSaleRequestsRepository(Ref ref) {
  return EcSaleRequestsRepositoryImpl(
    ref.watch(ecSaleRequestsDatasourceProvider),
  );
}

@riverpod
IBSFGeneratePdfDatasource bSFGeneratePdfDatasource(Ref ref) {
  return BSFGeneratePdfDatasource(
    translations: ref.watch(appLocalizationsProvider),
  );
}

@riverpod
IPrintBSFSaleRequestDatasource printBsfSaleRequestDatasource(Ref ref) {
  return PrintBSFSaleRequestDatasource(
    translations: ref.watch(appLocalizationsProvider),
  );
}

@riverpod
IEcPaymentFinalizationDatasource ecPaymentFinalizationDatasource(Ref ref) {
  return EcPaymentFinalizationDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcPaymentFinalizationRepository ecPaymentFinalizationRepository(Ref ref) {
  return EcPaymentFinalizationRepositoryImpl(
    ref.watch(ecPaymentFinalizationDatasourceProvider),
  );
}

@riverpod
SaleRequestArgs saleRequestArgs(Ref ref) {
  throw UnimplementedError();
}

@riverpod
IEcSellerDatasource ecSellerDatasource(Ref ref) {
  return EcSellerDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcSellerRepository ecSellerRepository(Ref ref) {
  return EcSellerRepositoryImpl(ref.watch(ecSellerDatasourceProvider));
}

@riverpod
ILocalBSFSaleRequestDraftDatasource localBsfSaleRequestDraftDatasource(
  Ref ref,
) {
  return LocalBSFSaleRequestDraftDatasource(
    ref.watch(hiveBoxSaleRequestDraftProvider),
  );
}

@riverpod
ILocalBSFSaleRequestDraftRepository localBsfSaleRequestDraftRepository(
  Ref ref,
) {
  return LocalBSFSaleRequestDraftRepositoryImpl(
    ref.watch(localBsfSaleRequestDraftDatasourceProvider),
  );
}
