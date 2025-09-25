import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/transfer_justification/transfer_justification.dart';
import 'transfer_justification.dart';

part 'soap_transfer_justification_repository_provider.g.dart';

@riverpod
ISoapTransferJustificationRepository soapTransferJustificationRepository(
  Ref ref,
) {
  return SoapTransferJustificationRepositoryImpl(
    ref.watch(soapTransferJustificationDatasourceProvider),
  );
}
