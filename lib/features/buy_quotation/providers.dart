import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/soap/soap.dart';
import 'package:celta_inventario/features/buy_quotation/data/datasource/datasource.dart';
import 'package:celta_inventario/features/buy_quotation/domain/repository/repository.dart';
import 'package:celta_inventario/features/buy_quotation/data/repository/repository.dart';

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
