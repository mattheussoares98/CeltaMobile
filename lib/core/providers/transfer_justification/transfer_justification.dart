import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/transfer_justification/transfer_justification.dart';
import '../../domain/repositories/transfer_justification/transfer_justification.dart';
import '../../data/repositories/transfer_justification/transfer_justification.dart';
import '../soap/soap.dart';

part 'transfer_justification.g.dart';

@riverpod
ISoapTransferJustificationDatasource soapTransferJustificationDatasource(
  Ref ref,
) {
  return SoapTransferJustificationDatasource(ref.watch(soapRequestProvider));
}

@riverpod
ISoapTransferJustificationRepository soapTransferJustificationRepository(
  Ref ref,
) {
  return SoapTransferJustificationRepositoryImpl(
    ref.watch(soapTransferJustificationDatasourceProvider),
  );
}
