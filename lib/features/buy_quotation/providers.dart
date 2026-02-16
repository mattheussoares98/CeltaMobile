import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repository/repository.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadBuyQuotationsDatasource soapLoadBuyQuotationsDatasource(Ref ref) {
  return SoapLoadBuyQuotationsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadBuyQuotationsRepository soapLoadBuyQuotationsRepository(Ref ref) {
  return SoapLoadBuyQuotationsRepositoryImpl(
    ref.watch(soapLoadBuyQuotationsDatasourceProvider),
  );
}

@riverpod
ISoapInsertUpdateBuyQuotationDatasource soapInsertUpdateBuyQuotationDatasource(
  Ref ref,
) {
  return SoapInsertUpdateBuyQuotationDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapInsertUpdateBuyQuotationRepository soapInsertUpdateBuyQuotationRepository(
  Ref ref,
) {
  return SoapInsertUpdateBuyQuotationRepositoryImpl(
    ref.watch(soapInsertUpdateBuyQuotationDatasourceProvider),
  );
}
