import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/transfer_justification/transfer_justification.dart';
import '../soap/soap.dart';

part 'soap_transfer_justification_datasource_provider.g.dart';

@riverpod
ISoapTransferJustificationDatasource soapTransferJustificationDatasource(
  Ref ref,
) {
  return SoapTransferJustificationDatasource(ref.watch(soapRequestProvider));
}
