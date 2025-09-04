import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

import '../domain/contracts/contracts.dart';
import '../infraestructure/infrastructure.dart';

part 'http_provider.g.dart';

@riverpod
HttpClient httpClient(Ref ref) {
  return HttpAdapter(http.Client());
}
