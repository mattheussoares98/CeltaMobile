import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/infraestructure/infrastructure.dart';
import 'package:celta_inventario/core/providers/http/http.dart';

part 'soap.g.dart';

@Riverpod(keepAlive: true)
SoapRequest soapRequest(Ref ref) {
  return SoapAdapter(ref.watch(clientProvider));
}
