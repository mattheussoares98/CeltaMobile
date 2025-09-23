import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'client_http_provider.g.dart';

@Riverpod(keepAlive: true)
http.Client clientHttp(Ref ref) {
  return http.Client();
}
