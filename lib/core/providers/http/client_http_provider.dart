import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/contracts/contracts.dart';
import '../../infraestructure/infrastructure.dart';

part 'client_http_provider.g.dart';

@Riverpod(keepAlive: true)
HttpClient clientHttp(Ref ref) {
  return HttpAdapter(http.Client());
}
