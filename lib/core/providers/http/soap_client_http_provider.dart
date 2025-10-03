import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'soap_client_http_provider.g.dart';

@Riverpod(keepAlive: true)
http.Client soapClientHttp(Ref ref) {
  return http.Client();
}
