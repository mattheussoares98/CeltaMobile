import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/contracts/contracts.dart';
import '../../infraestructure/infrastructure.dart';
import '../http/http.dart';

part 'soap.g.dart';

@Riverpod(keepAlive: true)
SoapRequest soapRequest(Ref ref) {
  return SoapAdapter(ref.watch(clientProvider));
}
