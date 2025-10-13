import 'package:celta_intelligence/features/expedition_conference/data/datasource/soap_load_expedition_documents_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/soap/soap.dart';
import 'data/datasource/datasource.dart';
import 'domain/repositories/repositories.dart';

part 'providers.g.dart';

@riverpod
ISoapLoadExpeditionDocumentsDatasource soapLoadExpeditionDocumentsDatasource(
  Ref ref,
) {
  return SoapLoadExpeditionDocumentsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadExpeditionDocumentsRepository soapLoadExpeditionDocumentsRepository(
  Ref ref,
) {
  return SoapLoadExpeditionDocumentsRepositoryImpl(
    ref.watch(soapLoadExpeditionDocumentsDatasourceProvider),
  );
}

@riverpod
ISoapLoadPendingProductsDatasource soapLoadPendingProductsDatasource(Ref ref) {
  return SoapLoadPendingProductsDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapLoadPendingProductsRepository soapLoadPendingProductsRepository(Ref ref) {
  return SoapLoadPendingProductsRepositoryImpl(
    ref.watch(soapLoadPendingProductsDatasourceProvider),
  );
}
