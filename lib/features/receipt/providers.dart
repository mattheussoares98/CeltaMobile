import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/soap/soap.dart';
import 'package:celta_inventario/features/receipt/data/datasource/datasource.dart';
import 'package:celta_inventario/features/receipt/domain/repository/repository.dart';
import 'package:celta_inventario/features/receipt/data/repository/repository.dart';

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

@riverpod
ISoapInsertProductNotFoundDatasource soapInsertProductNotFoundDatasource(
  Ref ref,
) {
  return SoapInsertProductNotFoundDatasource(ref.watch(soapRequestProvider));
}
