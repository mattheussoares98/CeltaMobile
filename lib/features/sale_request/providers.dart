import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/hive/hive.dart';
import '../../core/providers/http/http.dart';
import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repository/repository.dart';

part 'providers.g.dart';

@riverpod
ILocalSaleRequestDatasource localSaleRequestDatasource(Ref ref) {
  return LocalSaleRequestDatasource(ref.watch(hiveBoxSaleRequestProvider));
}

@riverpod
ILocalSaleRequestRepository localSaleRequestRepository(Ref ref) {
  return LocalSaleRequestRepositoryImpl(
    ref.watch(localSaleRequestDatasourceProvider),
  );
}

@riverpod
ISoapProcessCartDatasource soapProcessCartDatasource(Ref ref) {
  return SoapProcessCartDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapProcessCartRepository soapProcessCartRepository(Ref ref) {
  return SoapProcessCartRepositoryImpl(
    ref.watch(soapProcessCartDatasourceProvider),
  );
}

@riverpod
ISoapSaveSaleRequestDatasource soapSaveSaleRequestDatasource(Ref ref) {
  return SoapSaveSaleRequestDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapSaveSaleRequestRepository soapSaveSaleRequestRepository(Ref ref) {
  return SoapSaveSaleRequestRepositoryImpl(
    ref.watch(soapSaveSaleRequestDatasourceProvider),
  );
}

@riverpod
ILocalLastSavedSaleRequestDatasource localLastSavedSaleRequestDatasource(
  Ref ref,
) {
  return LocalLastSavedSaleRequestDatasource(
    ref.watch(hiveBoxSaleRequestProvider),
  );
}

@riverpod
ILocalLastSavedSaleRequestRepository localLastSavedSaleRequestRepository(
  Ref ref,
) {
  return LocalLastSavedSaleRequestRepositoryImpl(
    ref.watch(localLastSavedSaleRequestDatasourceProvider),
  );
}

@riverpod
IPrintSoapLastSavedSaleRequestDatasource
printSoapLastSavedSaleRequestDatasource(Ref ref) {
  return PrintSoapLastSavedSaleRequestDatasource();
}

@riverpod
IPrintSaleRequestRepository printSaleRequestRepository(Ref ref) {
  return PrintSaleRequestRepositoryImpl(
    ref.watch(printSoapLastSavedSaleRequestDatasourceProvider),
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
ISoapGeneratePdfDatasource soapGeneratePdfDatasource(Ref ref) {
  return SoapGeneratePdfDatasource();
}

@riverpod
IGeneratePdfRepository generatePdfRepository(Ref ref) {
  return GeneratePdfRepositoryImpl(
    ref.watch(soapGeneratePdfDatasourceProvider),
    ref.watch(bSFGeneratePdfDatasourceProvider),
  );
}

@riverpod
IEcGetSaleRequestsDatasource ecGetSaleRequestsDatasource(Ref ref) {
  return EcGetSaleRequestsDatasource(ref.watch(httpClientProvider));
}

@riverpod
IEcGetSaleRequestsRepository ecGetSaleRequestsRepository(Ref ref) {
  return EcGetSaleRequestsRepositoryImpl(
    ref.watch(ecGetSaleRequestsDatasourceProvider),
  );
}

@riverpod
IBSFGeneratePdfDatasource bSFGeneratePdfDatasource(Ref ref) {
  return BSFGeneratePdfDatasource();
}
