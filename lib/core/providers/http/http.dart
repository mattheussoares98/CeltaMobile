import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:celta_inventario/core/domain/contracts/contracts.dart';
import 'package:celta_inventario/core/infraestructure/infrastructure.dart';

part 'http.g.dart';

@Riverpod(keepAlive: true)
http.Client client(Ref ref) {
  return http.Client();
}

@Riverpod(keepAlive: true)
HttpClient httpClient(Ref ref) {
  return HttpAdapter(ref.watch(clientProvider));
}
