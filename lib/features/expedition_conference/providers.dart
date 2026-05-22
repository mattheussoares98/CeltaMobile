import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/providers/soap/soap.dart';
import 'package:celta_inventario/features/expedition_conference/data/datasource/datasource.dart';
import 'package:celta_inventario/features/expedition_conference/domain/repositories/repositories.dart';
import 'package:celta_inventario/features/expedition_conference/data/repositories/repositories.dart';

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

@riverpod
ISoapConfirmConferenceDatasource soapConfirmConferenceDatasource(Ref ref) {
  return SoapConfirmConferenceDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapConfirmConferenceRepository soapConfirmConferenceRepository(Ref ref) {
  return SoapConfirmConferenceRepositoryImpl(
    ref.watch(soapConfirmConferenceDatasourceProvider),
  );
}
