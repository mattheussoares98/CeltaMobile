import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/contracts/contracts.dart';
import '../../infraestructure/infrastructure.dart';

part 'http.g.dart';

@Riverpod(keepAlive: true)
http.Client client(Ref ref) {
  return http.Client();
}

@Riverpod(keepAlive: true)
HttpClient httpClient(Ref ref) {
  return HttpAdapter(ref.watch(clientProvider));
}
