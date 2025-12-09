import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repository/repository.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadReceiptsDatasource soapLoadReceiptsDatasource(Ref ref) {
  return SoapLoadReceiptsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadReceiptsRepository soapLoadReceiptsRepository(Ref ref) {
  return SoapLoadReceiptsRepositoryImpl(
    ref.watch(soapLoadReceiptsDatasourceProvider),
  );
}

@riverpod
ISoapUpdateObservationsDatasource soapUpdateObservationsDatasource(Ref ref) {
  return SoapUpdateObservationsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLiberateDocumentDatasource soapLiberateDocumentDatasource(Ref ref) {
  return SoapLiberateDocumentDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapUpdateProductDatasource soapUpdateProductDatasource(Ref ref) {
  return SoapUpdateProductDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapUpdateProductRepository soapUpdateProductRepository(Ref ref) {
  return SoapUpdateProductRepositoryImpl(
    ref.watch(soapUpdateProductDatasourceProvider),
  );
}

@riverpod
ISoapAnnulQuantityDatasource soapAnnulQuantityDatasource(Ref ref) {
  return SoapAnnulQuantityDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadProductsNotFoundDatasource soapLoadProductsNotFoundDatasource(
  Ref ref,
) {
  return SoapLoadProductsNotFoundDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadProductsNotFoundRepository soapLoadProductsNotFoundRepository(
  Ref ref,
) {
  return SoapLoadProductsNotFoundRepositoryImpl(
    ref.watch(soapLoadProductsNotFoundDatasourceProvider),
  );
}
